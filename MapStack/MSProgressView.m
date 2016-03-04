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
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    drawLinearGradient(context, self.bounds, [UIColor whiteColor].CGColor, [MSSingleton sharedSingleton].themeColor.CGColor);
    
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

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    /* again with __bridge to mix Objective-C with vanilla C */
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

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
