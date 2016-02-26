//
//  MSLocation.h
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MSLocation : NSObject

@property (nonatomic, copy, readonly) NSString                    *title;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D    coordinate;
@property (nonatomic, assign, readonly) CGFloat                   distance;
@property (nonatomic, strong, readonly) UIImage                   *locationImage;

- (void)setTitle:(NSString *)title;
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setDistance:(CGFloat)distance;
- (void)setLocationImage:(UIImage *)locationImage;

- (double)getDistanceFromPoint:(CLLocationCoordinate2D)pointA toPoint:(CLLocationCoordinate2D)pointB;

@end
