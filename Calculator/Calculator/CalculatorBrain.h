//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Robert Cole on 6/30/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (readonly) id program;

- (void)pushOperand:(double)operand;

- (void)pushVariable:(NSString *)variable;

- (void)clearAllOperands;

- (double)performOperation:(NSString *)operation;

+ (double)runProgram:(id)program;

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

+ (NSString *)descriptionOfProgram:(id)program;

+ (double)popOperandOffStack:(NSMutableArray *)stack;

@end
