//
//  MathProblemGenerator.h
//  LearningFun
//
//  Created by Charles H. Cheng on 1/14/18.
//  Copyright © 2018 chchench. All rights reserved.
//

#ifndef MathProblemGenerator_h
#define MathProblemGenerator_h

#define PROBLEM_TYPE_ADDITION       0
#define PROBLEM_TYPE_SUBTRACTION    1
#define PROBLEM_TYPE_MULTIPLICATION 2
#define PROBLEM_TYPE_DIVISION       3
#define PROBLEM_TYPE_CARDINALITY    4

@interface MathProblemGenerator : NSObject

@property (nonatomic) BOOL includeAddition;
@property (nonatomic) BOOL includeSubtraction;
@property (nonatomic) BOOL includeMultiplication;
@property (nonatomic) BOOL includeDivision;
@property (nonatomic) SInt16 maxNumValue;

- (id)init:(BOOL)includeAddition andIncSubtraction:(BOOL)includeSubtraction andIncMultiplication:(BOOL)includeMultiplication
    andIncDivision:(BOOL)includeDivision andMaxNumValue:(SInt16)maxNumValue;

- (BOOL)generateNewProblem:(SInt16 *)operand1 andOperand2:(SInt16 *)operand2 andOperator:(UInt8 *)operator andAnswer:(SInt16 *)correctAnswer;

@end

#endif /* MathProblemGenerator_h */
