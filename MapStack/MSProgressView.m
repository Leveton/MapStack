//
//  MSProgressView.m
//  MapStack
//
//  Created by Mike Leveton on 3/3/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSProgressView.h"
#import "MSSingleton.h"

/* we don't need an interface declaration if we don't have any private properties, methods and don't conform to any protocols */

@implementation MSProgressView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect progressFrame = [[self progressView] frame];
    progressFrame.origin = CGPointMake([self horizontallyCenteredFrameForChildFrame:progressFrame].origin.x, [self verticallyCenteredFrameForChildFrame:progressFrame].origin.y);
    [[self progressView] setFrame:progressFrame];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    /**
     besides Apple's comments above, this is also memory intensive and hits the CPU as opposed to UIKit which is offloaded to the GPU.
     So only override this method if you can't achieve the UI effect you want via UIKit.
     */
    
    /* Look, we're back in C World. This gets the 'canvas' upon which you can draw on */
    CGContextRef canvas        = UIGraphicsGetCurrentContext();
    
    /* get the device color space */
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    /* get the full range of the gradient */
    CGFloat colorLocations[]   = {0.0, 1.0};
    
    /* again with __bridge cast to mix Objective-C with vanilla C */
    NSArray *colorArray        = @[(__bridge id)[[UIColor whiteColor] CGColor], (__bridge id)[[[MSSingleton sharedSingleton] themeColor] CGColor]];
    
    CGGradientRef gradient     = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colorArray, colorLocations);
    
    /*Core Geometry helper functions again. If our view's size was 10x10, we are drawing a line from (5,0) to (5,10) */
    CGPoint startPoint         = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint           = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    /* cmd+click into these to see what they're doing */
    CGContextSaveGState(canvas);
    CGContextAddRect(canvas, rect);
    
    /* draw only on the shape passed in */
    CGContextClip(canvas);
    
    /* fills the entire view with the gradient */
    CGContextDrawLinearGradient(canvas, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(canvas);
    
    /* This is vanilla C, so we don't have ARC to free up memory when we're done */
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
}

#pragma mark - getters

- (UIActivityIndicatorView *)progressView{
    if (!_progressView){
        
        /*another custom initializer that takes an enum */
        _progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        /* use this view's Core Animation (CA Layer) to increase its z-axis (its third dimension if you will) */
        [[_progressView layer] setZPosition:2.0f];
        
        if (![MSSingleton sharedSingleton].themeColor) {
            [MSSingleton sharedSingleton].themeColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];
        }
        
        [_progressView setColor:[MSSingleton sharedSingleton].themeColor];
        
        [_progressView setHidden:YES];
        [self addSubview:_progressView];
    }
    return _progressView;
}

#pragma mark - helpers

/* we've used these before - we'll deal with code duplication later */
- (CGRect)verticallyCenteredFrameForChildFrame:(CGRect)childRect
{
    CGRect myBounds = [self bounds];
    childRect.origin.y = (CGRectGetHeight(myBounds)/2) - (CGRectGetHeight(childRect)/2);
    return childRect;
}

- (CGRect)horizontallyCenteredFrameForChildFrame:(CGRect)childRect{
    CGRect viewBounds = [self bounds];
    CGFloat listMinX = CGRectGetMidX(viewBounds) - (CGRectGetWidth(childRect)/2);
    CGRect newChildFrame = CGRectMake(listMinX,
                                      CGRectGetMinY(childRect),
                                      CGRectGetWidth(childRect),
                                      CGRectGetHeight(childRect));
    return CGRectIntegral(newChildFrame);
}

@end
