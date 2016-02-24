//
//  Car.h
//  MapStack
//
//  Created by Mike Leveton on 2/24/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Car : NSObject

/* number of doors is an encapsulated property of the Car class */
@property (nonatomic, assign, readonly) NSInteger numberOfDoors;

- (void)setNumberOfDoors:(NSInteger)numberOfDoors;
@end
