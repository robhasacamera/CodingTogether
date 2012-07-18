//
//  GraphViewController.h
//  Calculator
//
//  Created by Robert Cole on 7/13/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewControllerDataSource.h"

@interface GraphViewController : UIViewController

@property (nonatomic, strong) id <GraphViewControllerDataSource> dataSource;

@end
