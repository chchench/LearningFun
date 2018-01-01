//
//  MathProblemGenerator.m
//  LearningFun
//
//  Created by Charles H. Cheng on 1/14/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MathProblemGenerator.h"

@implementation MathProblemGenerator

- (id)init:(BOOL)includeAddition andIncSubtraction:(BOOL)includeSubtraction andIncMultiplication:(BOOL)includeMultiplication
andIncDivision:(BOOL)includeDivision andMaxNumValue:(SInt16)maxNumValue
{
    self.includeAddition = includeAddition;
    self.includeSubtraction = includeSubtraction;
    self.includeMultiplication = includeMultiplication;
    self.includeDivision = includeDivision;
    self.maxNumValue = maxNumValue;
    
    return self;
}

- (UInt8)selectProblemType
{
    UInt8 array[PROBLEM_TYPE_CARDINALITY];
    UInt8 maxValue = 0;
    
    if (self.includeAddition) {
        array[maxValue] = PROBLEM_TYPE_ADDITION;
        maxValue++;
    }
    if (self.includeSubtraction) {
        array[maxValue] = PROBLEM_TYPE_SUBTRACTION;
        maxValue++;
    }
    if (self.includeMultiplication) {
        array[maxValue] = PROBLEM_TYPE_MULTIPLICATION;
        maxValue++;
    }
    if (self.includeDivision) {
        array[maxValue] = PROBLEM_TYPE_DIVISION;
        maxValue++;
    }
    
    NSInteger randomNumber = arc4random_uniform(maxValue);
    
    return array[randomNumber];
}

- (BOOL)generateNewProblem:(SInt16 *)operand1 andOperand2:(SInt16 *)operand2 andOperator:(UInt8 *)operator andAnswer:(SInt16 *)correctAnswer
{
    UInt8 problemType = [self selectProblemType];
    
    SInt16 tempAnswer = arc4random_uniform(self.maxNumValue) + 1;
    SInt16 tempOperand1 = arc4random_uniform(self.maxNumValue) + 1;
    SInt16 tempOperand2 = arc4random_uniform(self.maxNumValue) + 1;
    float tempFloat = 0;
    
    *operator = problemType;
    
    switch (problemType) {
        case PROBLEM_TYPE_ADDITION:
            if (tempOperand1 > tempAnswer) {
                *operand1 = tempAnswer;
                *operand2 = tempOperand1 - tempAnswer;
                *correctAnswer = tempOperand1;
            }
            else {
                *operand1 = tempOperand1;
                *operand2 = tempAnswer - tempOperand1;
                *correctAnswer = tempAnswer;
            }
            break;
        case PROBLEM_TYPE_SUBTRACTION:
            if (tempOperand1 > tempOperand2) {
                *operand1 = tempOperand1;
                *operand2 = tempOperand2;
            }
            else {
                *operand1 = tempOperand2;
                *operand2 = tempOperand1;
            }
            *correctAnswer = *operand1 - *operand2;
            break;
        case PROBLEM_TYPE_MULTIPLICATION:
            tempOperand1 = arc4random_uniform(tempOperand1 >> 1) + 1;
            
            tempFloat = tempAnswer / tempOperand1;
            tempOperand2 = floor(tempFloat);
            tempAnswer = tempOperand1 * tempOperand2;
            *operand1 = tempOperand1;
            *operand2 = tempOperand2;
            *correctAnswer = tempAnswer;
            break;
        case PROBLEM_TYPE_DIVISION:
            tempOperand1 = arc4random_uniform(tempOperand1 >> 1) + 1;
            
            tempFloat = tempAnswer / tempOperand1;
            tempOperand2 = floor(tempFloat);
            tempAnswer = tempOperand1 * tempOperand2;
            *operand1 = tempAnswer;
            *operand2 = tempOperand1;
            *correctAnswer = tempOperand2;
            break;
    }
    
    return YES;
}

@end
