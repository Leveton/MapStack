//
//  MSRange.h
//  MapStack
//
//  Created by Mike Leveton on 3/7/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRange : NSObject
@property (nonatomic, assign, readonly) CGFloat startPoint;
@property (nonatomic, assign, readonly) CGFloat endPoint;

- (void)setStartPoint:(CGFloat)startPoint;
- (void)setEndPoint:(CGFloat)endPoint;
@end
