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

- (void)clearAllOperands;

- (double)performOperation:(NSString *)operation;

+ (double)runProgram:(id)program;

+ (NSString *)descriptionOfProgram:(id)program;

+ (double)popOperandOffStack:(NSMutableArray *)stack;

@end
