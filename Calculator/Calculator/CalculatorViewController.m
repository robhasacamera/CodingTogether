//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Robert Cole on 6/29/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc]init];
    }
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }

}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)clearPressed {
    //clear all operands
    //reset the display
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    NSString *operation = [sender currentTitle];
    
    double result = [self.brain performOperation:operation];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

@end
