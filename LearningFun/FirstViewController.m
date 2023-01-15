//
//  FirstViewController.m
//  LearningFun
//
//  Created by Charles H. Cheng on 12/7/17.
//  Copyright © 2017 chchench. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "MathProblemGenerator.h"

#import <AudioToolbox/AudioToolbox.h>


@interface FirstViewController ()

@property int digitChosen;

@property int operand1Total;
@property int operand2Total;
@property int answerTotal;
@property int numTimesWithIncorrectAnswer;

@property BOOL waitingToContinueMode;

@property (nonatomic, retain) NSMutableString *mathProblemStr;

@end

@implementation FirstViewController

{
    int op1DigitArray[MAX_NUM_DIGITS_OP1];
    int op2DigitArray[MAX_NUM_DIGITS_OP2];
    int ansDigitArray[MAX_NUM_DIGITS_ANS];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.digitChosen = -1;
    
    if ([touches count] == 1) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.digitImages];
        
        for (int i = 0; i < [self.digitArray count]; i++) {
            UIImageView *iView = self.digitArray[i];
            
            if (touchPoint.x > iView.frame.origin.x &&
                touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
                touchPoint.y > iView.frame.origin.y &&
                touchPoint.y < iView.frame.origin.y + iView.frame.size.height)
            {
                self.digitChosen = i;
                NSLog(@"User has chosen the digit \"%i\"", self.digitChosen);
                
                self.dragDigit.image = iView.image;
                
                self.touchOffset = CGPointMake(touchPoint.x - iView.frame.origin.x,
                                               touchPoint.y - iView.frame.origin.y);
                self.homePosition = CGPointMake(iView.frame.origin.x,
                                                iView.frame.origin.y);
                
                [self.view bringSubviewToFront:self.dragDigit];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dragDigit) {
        CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
        
        self.dragDigit.center = touchPoint;
        self.dragDigit.hidden = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    
    for (int i = 0; i < [self.answerArray count]; i++) {
        UIImageView *iView = self.answerArray[i];
    
        if (touchPoint.x > iView.frame.origin.x &&
            touchPoint.x < iView.frame.origin.x + iView.frame.size.width &&
            touchPoint.y > iView.frame.origin.y &&
            touchPoint.y < iView.frame.origin.y + iView.frame.size.height) {
         
            UIImageView *chosenDigit = self.digitArray[self.digitChosen];
            iView.image = chosenDigit.image;
            ansDigitArray[i] = self.digitChosen;
            
            NSLog(@"The digit \"%i\" has been inserted into answer lot [%i]", self.digitChosen, i);
            NSLog(@"Total sum for the answer is now %i", [self retrieveUserAnswer]);
            
            break;
        }
    }
    
    if (!self.dragDigit.hidden) self.dragDigit.hidden = YES;
}

- (IBAction)checkButtonPressed:(UIButton *)sender
{
    NSLog(@"Check button pressed");
    
    if (self.waitingToContinueMode) {
        [self setupNewMathProblem];
        [self resetUserAnswer];
        self.clearBtn.hidden = NO;
        
        return;
    }
    
    // Check to make sure none of the answer slots is empty.
    if (![self answerCompletelyFilled]) {
        NSLog(@"Not all the answer slots have been filled in.");
        return;
    }
    
    AppDelegate *app = ((AppDelegate*)[[UIApplication sharedApplication]delegate]);
    
    int userAnswer = [self retrieveUserAnswer];
    NSString *userAnswerStr = [[NSString alloc] initWithFormat:@"%i", userAnswer];

    if (userAnswer == self.answerTotal) {
        NSLog(@"User provided answer (%i) is CORRECT", userAnswer);
        
        self.waitingToContinueMode = YES;
        self.clearBtn.hidden = YES;
        
        NSString *answerLabel = [NSString stringWithFormat:@"Yes, the correct answer is %i!", self.answerTotal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.correctAnswerLabel setText:answerLabel];
            self.checkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.checkBtn.titleLabel setText:@"Next"];
        });
        
        // Write correctly answered problem to the DB
        [app.problemRecords addMathProblemToRecord:self.mathProblemStr userAnswer:userAnswerStr answeredCorrectly:1];
         
        AudioServicesPlayAlertSound(/* Calypso */ 1022);
        
        [NSThread sleepForTimeInterval:1 /* 1 seconds */];
    }
    else {
        NSLog(@"User provided answer (%i) is INCORRECT. Correct answer is %i", userAnswer, self.answerTotal);
                
        self.numTimesWithIncorrectAnswer++;
        AudioServicesPlayAlertSound(/* Choo Choo */ 1023);
        
        if (self.numTimesWithIncorrectAnswer >= 3 /* TBD - give user 3 tries */) {
            self.waitingToContinueMode = YES;
            self.clearBtn.hidden = YES;
            
            NSString *answerLabel = [NSString stringWithFormat:@"The correct answer is %i.", self.answerTotal];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.correctAnswerLabel setText:answerLabel];
                self.checkBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [self.checkBtn.titleLabel setText:@"Next"];
            });
            
            // Write incorrectly answered problem to the DB
            [app.problemRecords addMathProblemToRecord:self.mathProblemStr userAnswer:userAnswerStr answeredCorrectly:0];

            [NSThread sleepForTimeInterval:1 /* 1 seconds */];
        }
        else{
            [self resetUserAnswer];
        }
    }
}

- (IBAction)clearButtonPressed:(UIButton *)sender
{
    NSLog(@"Clear button pressed");
    
    [self resetUserAnswer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.operand1Array = [NSMutableArray arrayWithCapacity:MAX_NUM_DIGITS_OP1];
    [self.operand1Array addObject:self.op1_0];
    [self.operand1Array addObject:self.op1_1];
    [self.operand1Array addObject:self.op1_2];
    [self.operand1Array addObject:self.op1_3];

    self.operand2Array = [NSMutableArray arrayWithCapacity:MAX_NUM_DIGITS_OP2];
    [self.operand2Array addObject:self.op2_0];
    [self.operand2Array addObject:self.op2_1];
    [self.operand2Array addObject:self.op2_2];
    [self.operand2Array addObject:self.op2_3];
    
    self.answerArray = [NSMutableArray arrayWithCapacity:MAX_NUM_DIGITS_ANS];
    [self.answerArray addObject:self.answer_0];
    [self.answerArray addObject:self.answer_1];
    [self.answerArray addObject:self.answer_2];
    [self.answerArray addObject:self.answer_3];
    
    self.digitArray = [NSMutableArray arrayWithCapacity:MAX_NUM_DRAGGABLE];
    [self.digitArray addObject:self.digitImg0];
    [self.digitArray addObject:self.digitImg1];
    [self.digitArray addObject:self.digitImg2];
    [self.digitArray addObject:self.digitImg3];
    [self.digitArray addObject:self.digitImg4];
    [self.digitArray addObject:self.digitImg5];
    [self.digitArray addObject:self.digitImg6];
    [self.digitArray addObject:self.digitImg7];
    [self.digitArray addObject:self.digitImg8];
    [self.digitArray addObject:self.digitImg9];
    
    self.dragDigit.hidden = YES;
    
    [self setupNewMathProblem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// TBD: Make this adjustable via UI in the future
#define TEMP_MAX_MATH_PROBLEM_VALUE 100

- (void)setupNewMathProblem {
    // TBD - These settings should be read from Preferences bundle
    MathProblemGenerator *generator = [[MathProblemGenerator alloc] init:YES andIncSubtraction:YES andIncMultiplication:YES andIncDivision:YES andMaxNumValue:TEMP_MAX_MATH_PROBLEM_VALUE];
    
    SInt16 op1, op2, answer;
    UInt8 op;
    
    [generator generateNewProblem:&op1 andOperand2:&op2 andOperator:&op andAnswer:&answer];
    
    NSLog(@"NEW PROBLEM: Operand1 = [%i], Operand2 = [%i], Operator = [%i], Answer = [%i]", op1, op2, op, answer);
    
    self.operand1Total = op1;
    self.operand2Total = op2;
    self.answerTotal = answer;
    
    [self setOperandImages:op1 withArray:self.operand1Array withCount:4];
    [self setOperandImages:op2 withArray:self.operand2Array withCount:4];
    
    switch (op) {
        case PROBLEM_TYPE_ADDITION:
            self.op.image = [UIImage imageNamed:@"plus_s"];
            self.mathProblemStr = [NSMutableString stringWithFormat:@"%i + %i = %i", self.operand1Total, self.operand2Total, self.answerTotal];
            break;
        case PROBLEM_TYPE_SUBTRACTION:
            self.op.image = [UIImage imageNamed:@"minus_s"];
            self.mathProblemStr = [NSMutableString stringWithFormat:@"%i - %i = %i", self.operand1Total, self.operand2Total, self.answerTotal];
            break;
        case PROBLEM_TYPE_MULTIPLICATION:
            self.op.image = [UIImage imageNamed:@"times_s"];
            self.mathProblemStr = [NSMutableString stringWithFormat:@"%i * %i = %i", self.operand1Total, self.operand2Total, self.answerTotal];
            break;
        case PROBLEM_TYPE_DIVISION:
            self.op.image = [UIImage imageNamed:@"divided_by_s"];
            self.mathProblemStr = [NSMutableString stringWithFormat:@"%i / %i = %i", self.operand1Total, self.operand2Total, self.answerTotal];
            break;
    }
    
    [self prepAnswerArea:answer];
    
    self.numTimesWithIncorrectAnswer = 0;
    self.correctAnswerLabel.text = @" ";
    
    self.waitingToContinueMode = NO;
}

- (void)resetUserAnswer
{
    for (int i = 0; i < MAX_NUM_DIGITS_ANS; i++) {
        ansDigitArray[i] = 0;
        UIImageView *iView = self.answerArray[i];
        iView.image = nil;
    }
}

- (BOOL)answerCompletelyFilled
{
    for (int i = 0; i < MAX_NUM_DIGITS_ANS; i++) {
        UIImageView *iView = self.answerArray[i];
        if (!iView.hidden && (iView.image == nil)) return NO;
    }
    
    return YES;
}

- (int)retrieveUserAnswer
{
    int total = 0;
    int digit_multiplier = 1;
    for (int i = 0; i < MAX_NUM_DIGITS_ANS; i++) {
        total += ansDigitArray[i] * digit_multiplier;
        digit_multiplier *= 10;
    }
    
    return total;
}

- (void)prepAnswerArea:(int)answerToSet
{
    self.answer_3.image = nil;
    self.answer_2.image = nil;
    self.answer_1.image = nil;
    self.answer_0.image = nil;
    
    self.answer_sign.hidden = (answerToSet >= 0);
    
    answerToSet = abs(answerToSet);

    self.answer_3.hidden = !(answerToSet > 999);
    self.answer_2.hidden = !(answerToSet > 99);
    self.answer_1.hidden = !(answerToSet > 9);
    self.answer_0.hidden = NO;
}

- (void)setOperandImages:(int)numberToSet withArray:(NSMutableArray *)opArray withCount:(int)opArraySize
{
    for (int i = 0; i < opArraySize; i++) {
        int digit = numberToSet % 10;

        UIImageView *v = [opArray objectAtIndex:i];
        UIImageView *targetImg = self.digitArray[digit];
        
        if (digit > 0) {
            v.image = targetImg.image;
            v.hidden = NO;
        }
        else if (numberToSet > 0 || i == 0) {
            v.image = targetImg.image;
            v.hidden = NO;
        }
        else {
            v.hidden = YES;
        }
        
        numberToSet /= 10;
    }
}


@end
