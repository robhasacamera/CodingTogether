//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Robert Cole on 6/30/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;

- (double)popOperand;

- (double)performOperation:(NSString *)operation;

@end
