//
//  MSLocation.m
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocation.h"

@implementation MSLocation

#pragma mark - setters

- (void)setTitle:(NSString *)title{
    _title = title;
}

- (void)setType:(NSString *)type{
    _type = type;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate{
    _coordinate = coordinate;
}

- (void)setDistance:(CGFloat)distance{
    _distance = distance;
}

- (void)setLocationId:(NSInteger)locationId{
    _locationId = locationId;
}

- (void)setFavoritesOrder:(NSInteger)favoritesOrder{
    _favoritesOrder = favoritesOrder;
}

- (void)setLocationImage:(UIImage *)locationImage{
    _locationImage = locationImage;
}


- (double)getDistanceFromPoint:(CLLocationCoordinate2D)pointA toPoint:(CLLocationCoordinate2D)pointB{
    
    return sqrt(((pointA.latitude - pointB.latitude) * 2) + ((pointA.longitude - pointB.longitude) * 2));
}

@end
