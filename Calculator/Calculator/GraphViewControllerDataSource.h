//
//  GraphViewControllerDataSource.h
//  Calculator
//
//  Created by Robert Cole on 7/17/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GraphViewControllerDataSource <NSObject>

- (float)getYValueForXValue:(float)xValue;

- (NSString *)getGraphEquation;

@end