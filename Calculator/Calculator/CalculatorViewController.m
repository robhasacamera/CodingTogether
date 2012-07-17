//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Robert Cole on 6/29/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

#pragma mark - Private properties and operations

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;

- (void)appendDigitToDisplay:(NSString *)digitAsString;

- (void)updateDisplay;

@end

#pragma mark - Implementation

@implementation CalculatorViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
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
    if ([self.display.text rangeOfString:@"."].location == NSNotFound) {
        [self appendDigitToDisplay:@"."];
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    [self updateDisplay];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed {
    [self.brain clearAllOperands];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
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

- (IBAction)undoPressed {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringToIndex:([self.display.text length] - 1)];
        
        if ([self.display.text length] <= 0) {
            self.userIsInTheMiddleOfEnteringANumber = NO;
            self.display.text = @"0";
        }
    } else {
        [self.brain undoLastOperationVariableOrOperand];
        [self updateDisplay];
    }
}

#pragma mark - Methods (private)

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGraphSegueIdentifier]) {
        if ([segue.destinationViewController isKindOfClass:[GraphViewController class]]) {
            ((GraphViewController *)segue.destinationViewController).dataSource = self;
        }
    }
}

#pragma mark - GraphViewControllerDataSource methods

- (float)getYValueForXValue:(float)xValue {
    return 0;
}

- (NSString *)getGraphEquation {
    return [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
