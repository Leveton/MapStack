//
//  Car.m
//  MapStack
//
//  Created by Mike Leveton on 2/24/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "Car.h"

@interface Car()

/* number of windows is a private property of the Car class */
@property (nonatomic, assign) NSInteger numberOfWindows;
@end

@implementation Car

#pragma mark - setters

/* this public method is implemented privately. A private property is set in this implementation */
- (void)setNumberOfDoors:(NSInteger)numberOfDoors{
    _numberOfDoors = numberOfDoors;
    
    /* value of the private variable depends on the public variable */
    _numberOfWindows = _numberOfDoors + 2;
}

@end
