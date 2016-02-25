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

/* overriding the object's initialization method inherited from NSObject */
- (id)init{
    
    self = [super init];
    
    if (self) {
        /* the object was successfully initialized, go to town */
    }
    
    return self;
}

#pragma mark - setters

- (void)setNumberOfDoors:(NSInteger)numberOfDoors{
    _numberOfDoors = numberOfDoors;
    
    /* number of windows is double for a house object than a car object */
    _numberOfWindows = _numberOfDoors + 4;
}

#pragma mark - class methods

+ (NSInteger)someCompexOperationUniqueToHouse{
    
    NSInteger someNumberDerivedAfterIntenseCalculation = 7;
    return someNumberDerivedAfterIntenseCalculation;
}
@end
