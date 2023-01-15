//
//  FirstViewController.h
//  LearningFun
//
//  Created by Charles H. Cheng on 12/7/17.
//  Copyright © 2017 chchench. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_NUM_DIGITS_OP1  4
#define MAX_NUM_DIGITS_OP2  4
#define MAX_NUM_DIGITS_ANS  4
#define MAX_NUM_DRAGGABLE   10

@interface FirstViewController : UIViewController


@property (nonatomic, weak) IBOutlet UIImageView *op1_3;
@property (nonatomic, weak) IBOutlet UIImageView *op1_2;
@property (nonatomic, weak) IBOutlet UIImageView *op1_1;
@property (nonatomic, weak) IBOutlet UIImageView *op1_0;

@property (nonatomic, weak) IBOutlet UIImageView *op2_3;
@property (nonatomic, weak) IBOutlet UIImageView *op2_2;
@property (nonatomic, weak) IBOutlet UIImageView *op2_1;
@property (nonatomic, weak) IBOutlet UIImageView *op2_0;

@property (nonatomic, weak) IBOutlet UIImageView *op;

@property (nonatomic, weak) IBOutlet UIImageView *answer_sign;

@property (nonatomic, weak) IBOutlet UIImageView *answer_3;
@property (nonatomic, weak) IBOutlet UIImageView *answer_2;
@property (nonatomic, weak) IBOutlet UIImageView *answer_1;
@property (nonatomic, weak) IBOutlet UIImageView *answer_0;

@property (nonatomic, weak) IBOutlet UIImageView *dragDigit;

@property (nonatomic, weak) IBOutlet UIImageView *digitImg1;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg2;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg3;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg4;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg5;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg6;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg7;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg8;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg9;
@property (nonatomic, weak) IBOutlet UIImageView *digitImg0;

@property (nonatomic, weak) IBOutlet UIButton *checkBtn;
@property (nonatomic, weak) IBOutlet UIButton *clearBtn;

@property (nonatomic, weak) IBOutlet UILabel *correctAnswerLabel;

@property (nonatomic, weak) IBOutlet UIStackView *digitImages;

@property (nonatomic, strong) NSMutableArray *operand1Array;
@property (nonatomic, strong) NSMutableArray *operand2Array;
@property (nonatomic, strong) NSMutableArray *answerArray;

@property (nonatomic, strong) NSMutableArray *digitArray;

@property (nonatomic, assign) CGPoint touchOffset;
@property (nonatomic, assign) CGPoint homePosition;


@property (nonatomic) SInt16 mathProblemOp1;
@property (nonatomic) SInt16 mathProblemOp2;
@property (nonatomic) SInt16 mathProblemAnswer;
@property (nonatomic) UInt8 mathProblemOperand;


@end

