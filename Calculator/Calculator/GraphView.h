//
//  GraphView.h
//  Calculator
//
//  Created by Robert Cole on 7/17/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewDataSource.h"

@interface GraphView : UIView

@property (nonatomic, strong) IBOutlet UILabel *algorithmLabel;
@property (nonatomic, weak) NSObject <GraphViewDataSource> *dataSource;
@property (nonatomic) CGPoint origin;
@property (nonatomic) float scale;

@end
