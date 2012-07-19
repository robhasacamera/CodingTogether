//
//  GraphViewController.m
//  Calculator
//
//  Created by Robert Cole on 7/13/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphViewDataSource.h"

@interface GraphViewController () <GraphViewDataSource>

- (void)setup;

@end

@implementation GraphViewController

@synthesize dataSource = _dataSource;
@synthesize graphView = _graphView;

- (void)setup {
    self.graphView.dataSource = self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // setup
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.graphView.dataSource = self;
}

- (void)viewDidUnload
{
    [self setGraphView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (float)getYValueForXValue:(float)xValue {
    return [self.dataSource getYValueForXValue:xValue];
}

- (NSString *)getGraphEquation {
    return [self.dataSource getGraphEquation];
}

@end
