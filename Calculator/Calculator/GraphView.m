//
//  GraphView.m
//  Calculator
//
//  Created by Robert Cole on 7/17/12.
//  Copyright (c) 2012 Clearwire. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView () <UIGestureRecognizerDelegate>

- (void)setup;

@end

@implementation GraphView

@synthesize algorithmLabel = _algorithmLabel;
@synthesize dataSource = _dataSource;

@synthesize origin = _origin;
@synthesize scale = _scale;

#pragma mark - Initialization

- (void)setup {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    [self addGestureRecognizer:pinchGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tapGesture.numberOfTapsRequired = 3;
    [self addGestureRecognizer:tapGesture];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Custom Drawing Code

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
            
            float yValueForDrawing = (self.origin.y - (yValue * self.scale));
            
            if (i == 0) {
                CGContextMoveToPoint(context, i, yValueForDrawing);
            } else {
                CGContextAddLineToPoint(context, i, yValueForDrawing);
            }
        }
            
        CGContextStrokePath(context);
    } else {
        self.algorithmLabel.text = @"GraphView's dataSource is undefined";
    }
}

#pragma mark - Gesture Handling

- (void)pan:(UIPanGestureRecognizer *)panGesture {
    if ((panGesture.state == UIGestureRecognizerStateChanged) 
        || (panGesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [panGesture translationInView:self];
    
        CGPoint newOrigin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
    
        self.origin = newOrigin;
    
        [panGesture setTranslation:CGPointMake(0.0, 0.0) inView:self];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)pinchGesture {
    if ((pinchGesture.state == UIGestureRecognizerStateChanged)
        || (pinchGesture.state == UIGestureRecognizerStateEnded)) {
        
        self.scale *= pinchGesture.scale;
        
        pinchGesture.scale = 1.0;
    }
}

- (void)tap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [tapGesture locationInView:self];
    }
}

#pragma mark - Properties Getters and Setters

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

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    
    [self setNeedsDisplay];
}

- (void)setScale:(float)scale {
    _scale = scale;
    
    [self setNeedsDisplay];
}

@end
