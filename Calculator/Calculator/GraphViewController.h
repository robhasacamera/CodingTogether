//
//  GraphViewController.h
//  Calculator
//
//  Created by Robert Cole on 7/13/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewControllerDataSource.h"
#import "GraphView.h"
#import "SplitViewBarButtonPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonPresenter>

@property (nonatomic, strong) id <GraphViewControllerDataSource> dataSource;
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;

@end
