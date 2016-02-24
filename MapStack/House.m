//
//  House.m
//  MapStack
//
//  Created by Mike Leveton on 2/24/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "House.h"

@interface House()

/* number of windows is a private property of the Car class */
@property (nonatomic, assign) NSInteger numberOfWindows;
@end

@implementation House

#pragma mark - setters

- (void)setNumberOfDoors:(NSInteger)numberOfDoors{
    _numberOfDoors = numberOfDoors;
    
    /* number of windows is double for a house object than a car object */
    _numberOfWindows = _numberOfDoors + 4;
}

@end
