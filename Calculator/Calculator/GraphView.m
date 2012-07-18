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
