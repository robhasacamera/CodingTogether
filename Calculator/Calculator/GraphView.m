//
//  GraphView.m
//  Calculator
//
//  Created by Robert Cole on 7/17/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView ()

@property (nonatomic) CGPoint origin;
@property (nonatomic) float scale;

@end

@implementation GraphView

@synthesize algorithmLabel = _algorithmLabel;
@synthesize dataSource = _dataSource;

@synthesize origin = _origin;
@synthesize scale = _scale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    
    if (self.dataSource) {
        self.algorithmLabel.text = [self.dataSource getGraphEquation];
        
        // Get context
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // start line
        CGContextBeginPath(context);
        
        // iterate over x (loop)
        for (int i=0; i<=self.bounds.size.width; i++) {
            // calculate x value for pixel using origin and scal
            float xValue = (i - self.origin.x) / self.scale;//need to take into account scale
            // get y value based on x value
            float yValue = [self.dataSource getYValueForXValue:xValue];
            // add line to point
            if (i == 0) {
                CGContextMoveToPoint(context, i, ((yValue + self.origin.y) * self.scale));
            } else {
                CGContextAddLineToPoint(context, i, ((yValue + self.origin.y) * self.scale));
            }
            NSLog(@"x, y = %f, %f", xValue, yValue);
        }
            
        CGContextStrokePath(context);
        
        NSLog(@"contentScaleFactor = %f", self.contentScaleFactor);
    } else {
        self.algorithmLabel.text = @"GraphView's dataSource is undefined";
    }
}

- (CGPoint)origin {
    if (!_origin.x || !_origin.y) {
        _origin = CGPointMake((self.bounds.size.width / 2), (self.bounds.size.height / 2));
    }
    
    return _origin;
}

- (float)scale {
    if (!_scale) {
        _scale = 1.0;
    }
    
    return _scale;
}

@end
