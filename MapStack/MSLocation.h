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

@interface MSLocation : NSObject<MKAnnotation>

@property (nonatomic, copy, readonly) NSString                    *title;
@property (nonatomic, copy, readonly) NSString                    *type;
@property (nonatomic, assign, readonly) CLLocationCoordinate2D    coordinate;
@property (nonatomic, assign, readonly) CGFloat                   distance;
@property (nonatomic, assign, readonly) NSInteger                 locationId;
@property (nonatomic, strong, readonly) UIImage                   *locationImage;

- (void)setTitle:(NSString *)title;
- (void)setType:(NSString *)type;
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)setDistance:(CGFloat)distance;
- (void)setLocationId:(NSInteger)locationId;
- (void)setLocationImage:(UIImage *)locationImage;

- (double)getDistanceFromPoint:(CLLocationCoordinate2D)pointA toPoint:(CLLocationCoordinate2D)pointB;

@end
