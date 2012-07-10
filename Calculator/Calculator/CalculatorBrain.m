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

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack;

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

- (void)undoLastOperationVariableOrOperand {
    [self.programStack removeLastObject];
}

#pragma mark -

// TODO: Need to strip out extra parentheses
+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *programStack = [program mutableCopy];
    
    NSString *description = nil;
    
    while ([programStack count] > 0) {
        if (description) {
            description = [[NSString alloc]initWithFormat:@"%@, %@", 
                           [self descriptionOfTopOfStack:programStack],
                           description];
        } else {
            description = [self descriptionOfTopOfStack:programStack];
        }
    } 
    
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
            NSNumber *value = [variableValues objectForKey:[program objectAtIndex:i]];
                
            if (value) {
                [program replaceObjectAtIndex:i withObject:value];
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

+ (NSSet *)variablesUsedInProgram:(id)program {
    NSSet *variables = nil;
    
    for (int i=0; i<[program count]; i++) {
        if ([[program objectAtIndex:i] isKindOfClass:[NSString class]] 
            && ![self isOperation:[program objectAtIndex:i]]) {
            if (!variables) {
                variables = [[NSSet alloc]init];
            }
            
            variables = [variables setByAddingObject:[program objectAtIndex:i]];
        }
    }
    
    return variables;
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
                                      @"-",
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

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    NSString *description = @"";
    
    if ([self isDoubleOperandOperation:[stack lastObject]]) {
        NSString *doubleOperation = [stack lastObject];
        
        [stack removeLastObject];
        
        NSString *secondOperand = [self descriptionOfTopOfStack:stack];
        NSString *firstOperand = [self descriptionOfTopOfStack:stack];
        
        
        description = [[NSString alloc]initWithFormat:@"(%@ %@ %@)",
                       firstOperand,
                       doubleOperation,
                       secondOperand];
    } else if ([self isSingleOperandOperation:[stack lastObject]]) {
        NSString *singleOperation = [stack lastObject];
        
        [stack removeLastObject];
        
        description = [singleOperation stringByAppendingFormat:@"(%@)", 
                       [self descriptionOfTopOfStack:stack]];
    } else if ([stack lastObject]){
        description = [[NSString alloc]initWithFormat:@"%@", 
                       [stack lastObject]];
        
        [stack removeLastObject];
        /* doesn't work correctly
        if ([stack lastObject]) {
            description = [[NSString alloc]initWithFormat:@"%@, %@",
                           [self descriptionOfTopOfStack:stack],
                           description];
        }
         */
    }

    return description;
}

@end
