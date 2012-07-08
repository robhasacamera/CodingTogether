//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Robert Cole on 6/30/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "CalculatorBrain.h"

#pragma mark - Private properties and operations

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *programStack;

+ (BOOL)isOperation:(NSString *)operation;

+ (BOOL)isDoubleOperandOperation:(NSString *)operation;

+ (BOOL)isSingleOperandOperation:(NSString *)operation;

+ (BOOL)isNoOperandOperation:(NSString *)operation;

@end

#pragma mark - Implementation

@implementation CalculatorBrain

@synthesize programStack = _programStack;

#pragma mark - Getters (public)

- (id)program {
    return [self.programStack copy];
}

#pragma mark - Getters (private)

- (NSMutableArray *)programStack {
    if (!_programStack) {
        _programStack = [[NSMutableArray alloc]init];
    }
    
    return _programStack;
}

#pragma mark - Methods (public)

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable {
    if (![CalculatorBrain isOperation:variable]) {
        [self.programStack addObject:variable];
    }
}

- (void)clearAllOperands {
    [self.programStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

#pragma mark -

// TODO: Need to implement according to ticket #14
+ (NSString *)descriptionOfProgram:(id)program {
    NSString *description = nil;
    
    //this is not what's needed
    for (int i=0; i<[program count]; i++) {
        if (description) {
            description = [description stringByAppendingString:@" "];
        } else {
            description = @"";
        }
        
        description = [description stringByAppendingFormat:@"%@", [program objectAtIndex:i]];
    }
    
    // regular (dual operand) operations are inserted before the last digit.
    
    // single operand operations 
    
    // pi and variables are inserted the same as doubles
    
    return description;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    if ([program isKindOfClass:[NSArray class]]) {
        program = [program mutableCopy];
        
        for (int i=0; i<[program count]; i++) {
            id programObject = [program objectAtIndex:i];
            
            if (![programObject isKindOfClass:[NSNumber class]] || ![self isOperation:programObject]) {
                NSNumber *variableValue = [variableValues objectForKey:programObject];
                
                if (!variableValues) {
                    variableValue = [NSNumber numberWithDouble:0];
                } 
                
                [program replaceObjectAtIndex:i withObject:variableValue];
            }
        }
    }
    
    return [self runProgram:program];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    
    if (topOfStack) {
        [stack removeLastObject];
    }
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            
            if (divisor) {
                result = [self popOperandOffStack:stack] / divisor;
            }
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = M_PI;
        }
    }
    
    return result;
}

#pragma mark - Methods (private)

+ (BOOL)isOperation:(NSString *)operation {
    return [self isDoubleOperandOperation:operation] 
    || [self isSingleOperandOperation:operation] 
    || [self isNoOperandOperation:operation];
}

+ (BOOL)isDoubleOperandOperation:(NSString *)operation {
    NSSet *doubleOperandOperations = [[NSSet alloc]initWithObjects:
                                      @"+",
                                      @"*",
                                      @"-"
                                      @"/",
                                      nil];
    
    return [doubleOperandOperations containsObject:operation];
}

+ (BOOL)isSingleOperandOperation:(NSString *)operation {
    NSSet *singleOperandOperations = [[NSSet alloc]initWithObjects:
                                      @"sin",
                                      @"cos",
                                      @"sqrt",
                                      nil];
    
    return [singleOperandOperations containsObject:operation];
}

+ (BOOL)isNoOperandOperation:(NSString *)operation {
    NSSet *noOperandOperations = [[NSSet alloc]initWithObjects:
                                  @"pi",
                                  nil];
    
    return [noOperandOperations containsObject:operation];
}

@end
