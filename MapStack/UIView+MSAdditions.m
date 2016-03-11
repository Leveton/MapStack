//
//  UIView+MSAdditions.m
//  MapStack
//
//  Created by Mike Leveton on 3/3/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "UIView+MSAdditions.h"

@implementation UIView (MSAdditions)

/* positions a child frame in the center of its parent */
- (CGRect)verticallyCenteredFrameForChildFrame:(CGRect)frame
{
    CGRect bounds  = [self bounds];
    frame.origin.y = (CGRectGetHeight(bounds)/2) - (CGRectGetHeight(frame)/2);
    return frame;
}

- (CGRect)horizontallyCenteredFrameForChildFrame:(CGRect)frame{
    CGRect bounds    = [self bounds];
    CGFloat minX     = CGRectGetMidX(bounds) - (CGRectGetWidth(frame)/2);
    CGRect newFrame  = CGRectMake(minX,
                                      CGRectGetMinY(frame),
                                      CGRectGetWidth(frame),
                                      CGRectGetHeight(frame));
    
    return CGRectIntegral(newFrame);
}
@end
