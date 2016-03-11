//
//  UIView+MSAdditions.h
//  MapStack
//
//  Created by Mike Leveton on 3/3/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (MSAdditions)

- (CGRect)verticallyCenteredFrameForChildFrame:(CGRect)childRect;
- (CGRect)horizontallyCenteredFrameForChildFrame:(CGRect)childRect;

@end
