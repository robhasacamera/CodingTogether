//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Robert Cole on 6/29/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

#pragma mark - Private properties and operations

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userAlreadyEnteredADecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;

- (void)resetStatesForNumberEntry;

- (void)appendDigitToDisplay:(NSString *)digitAsString;

- (void)updateDisplay;

@end

#pragma mark - Implementation

@implementation CalculatorViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userAlreadyEnteredADecimal;
@synthesize brain = _brain;
@synthesize testVariableValues;

#pragma mark - Getters (private)

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc]init];
    }
    
    return _brain;
}

#pragma mark - Actions

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    [self appendDigitToDisplay:digit];

}

- (IBAction)decimalPressed {
    if (!self.userAlreadyEnteredADecimal) {
        [self appendDigitToDisplay:@"."];
        
        self.userAlreadyEnteredADecimal = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    [self updateDisplay];
    
    [self resetStatesForNumberEntry];
}

- (IBAction)clearPressed {
    [self.brain clearAllOperands];
    self.display.text = @"0";
    [self resetStatesForNumberEntry];
    self.historyDisplay.text = @"";
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    
    [self.brain performOperation:operation];
    
    [self updateDisplay];
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.currentTitle;
    
    [self.brain pushVariable:variable];
    
    [self updateDisplay];
}

- (IBAction)test1Pressed {
    self.testVariableValues = [[NSDictionary alloc]initWithObjects:
                               [[NSArray alloc]initWithObjects:
                                [NSNumber numberWithDouble:10.5], 
                                [NSNumber numberWithDouble:2.0], 
                                [NSNumber numberWithDouble:5.3], 
                                nil] 
                                                           forKeys:
                               [[NSArray alloc]initWithObjects:
                                @"x", 
                                @"a", 
                                @"b", 
                                nil]];
    
    [self updateDisplay];
}

- (IBAction)test2Pressed {
    self.testVariableValues = [[NSDictionary alloc]initWithObjects:
                               [[NSArray alloc]initWithObjects:
                                [NSNumber numberWithDouble:8.78],  
                                [NSNumber numberWithDouble:3.0], 
                                nil] 
                                                           forKeys:
                               [[NSArray alloc]initWithObjects:
                                @"x",  
                                @"b", 
                                nil]];
    
    [self updateDisplay];
}

- (IBAction)test3Pressed {
    self.testVariableValues = nil;
    
    [self updateDisplay];
}

#pragma mark - Methods (private)

- (void)resetStatesForNumberEntry {
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userAlreadyEnteredADecimal = NO;
}



- (void)appendDigitToDisplay:(NSString *)digitAsString {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digitAsString];
    } else {
        self.display.text = digitAsString;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (void)updateDisplay {
    double result = [CalculatorBrain runProgram:self.brain.program usingVariableValues:self.testVariableValues];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
