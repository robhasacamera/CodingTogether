//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Robert Cole on 6/29/12.
//  Copyright (c) 2012 Robert Cole. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewControllerDataSource.h"
#import "RotatableViewController.h"

#define kGraphSegueIdentifier @"showGraph"

@interface CalculatorViewController : RotatableViewController <GraphViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;

@end
