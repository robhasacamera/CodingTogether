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

@interface CalculatorViewController () <UISplitViewControllerDelegate>

@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;

- (void)appendDigitToDisplay:(NSString *)digitAsString;

- (void)updateDisplay;

- (void)setup;

- (void)setSplitViewBarButton:(UIBarButtonItem *)barButtonItem;

- (void)removeSplitViewBarButton:(UIBarButtonItem *)barButtonItem;

@end

#pragma mark - Implementation

@implementation CalculatorViewController

@synthesize display;
@synthesize historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;

#pragma mark - Initialization

- (void)setup {
    if (self.splitViewController) {
        self.splitViewController.delegate = self;
        
        GraphViewController *graphViewController = [self.splitViewController.viewControllers lastObject];
        
        graphViewController.dataSource = self;
        
        self.splitViewController.presentsWithGesture = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - Getters (private)

- (CalculatorBrain *)brain {
    if (!_brain) {
        _brain = [[CalculatorBrain alloc]init];
    }
    
    return _brain;
}

#pragma mark - Actions

- (IBAction)graphButtonPressed:(id)sender {
    if (self.splitViewController) {
        GraphViewController *graphViewController = [self.splitViewController.viewControllers lastObject];
        
        [graphViewController.graphView setNeedsDisplay];
    }
}

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

    
    return [CalculatorBrain runProgram:self.brain.program usingVariableValues:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xValue] forKey:@"x"]];
}

- (NSString *)getGraphEquation {
    NSString *equation = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    if (![equation isEqualToString:@""]) {
        equation = [NSString stringWithFormat:@"y = %@", equation];
    }
    
    return equation;
}

#pragma mark - UISplitViewControllerDelegate methods

- (BOOL)splitViewController:(UISplitViewController *)svc 
   shouldHideViewController:(UIViewController *)vc 
              inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc 
     willHideViewController:(UIViewController *)aViewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = @"Calculator";
    
    [self setSplitViewBarButton:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc 
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self removeSplitViewBarButton:barButtonItem];
}

- (void)setSplitViewBarButton:(UIBarButtonItem *)barButtonItem {
    if (self.splitViewController) {
        UIToolbar *toolbar = ((GraphViewController *)[self.splitViewController.viewControllers lastObject]).toolbar;
        
        NSMutableArray *toolbarItems = [toolbar.items mutableCopy];
        
        if (self.splitViewBarButtonItem) {
            [toolbarItems removeObject:self.splitViewBarButtonItem];
        }
        
        if (barButtonItem) {
            [toolbarItems insertObject:barButtonItem atIndex:0];
        }
        
        [toolbar setItems:toolbarItems];
        
        self.splitViewBarButtonItem = barButtonItem;
    }
}

- (void)removeSplitViewBarButton:(UIBarButtonItem *)barButtonItem {
    if (self.splitViewController) {
        UIToolbar *toolbar = ((GraphViewController *)[self.splitViewController.viewControllers lastObject]).toolbar;
        
        NSMutableArray *toolbarItems = [toolbar.items mutableCopy];
        
        if (barButtonItem) {
            [toolbarItems removeObject:barButtonItem];
        }
        
        if (barButtonItem == self.splitViewBarButtonItem) {
            self.splitViewBarButtonItem = nil;
        }
        
        [toolbar setItems:toolbarItems];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
