//
//  GraphViewController.m
//  Calculator
//
//  Created by Robert Cole on 7/13/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphViewDataSource.h"

#define kGraphViewControllerScaleKey @"GraphViewControllerScale"
#define kGraphViewController

@interface GraphViewController () <GraphViewDataSource>

- (void)setup;

@end

@implementation GraphViewController

static NSString *scaleKey = @"GraphViewControllerScale";
static NSString *originKey = @"GraphViewControllerOrigin";

@synthesize dataSource = _dataSource;
@synthesize graphView = _graphView;

- (void)setup {
    self.graphView.dataSource = self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // setup
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    float scale = [defaults floatForKey:scaleKey];
    
    if (scale) {
        self.graphView.scale = scale;
    }
    
    NSString *originValue = [defaults objectForKey:originKey];
    
    if (originValue) {
        self.graphView.origin = CGPointFromString(originValue);
    }
}

- (void)viewDidDisappear:(BOOL)animated 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:self.graphView.scale forKey:scaleKey];
    
    [defaults setObject:NSStringFromCGPoint(self.graphView.origin) forKey:originKey];
    
    [self setGraphView:nil];
    
    [super viewDidUnload];
}

- (void)viewDidUnload
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (float)getYValueForXValue:(float)xValue {
    return [self.dataSource getYValueForXValue:xValue];
}

- (NSString *)getGraphEquation {
    return [self.dataSource getGraphEquation];
}

@end
