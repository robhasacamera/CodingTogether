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

- (void)resetStatesForNumberEntry;

- (void)appendDigitToDisplay:(NSString *)digitAsString;

@end

#pragma mark - Implementation

@implementation CalculatorViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize userAlreadyEnteredADecimal;
@synthesize brain = _brain;

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
    
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
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
    
    double result = [self.brain performOperation:operation];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    self.historyDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.currentTitle;
    
    [self.brain pushVariable:variable];
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

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
