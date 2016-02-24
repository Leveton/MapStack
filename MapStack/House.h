//
//  House.h
//  MapStack
//
//  Created by Mike Leveton on 2/24/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface House : NSObject

/* The House class has a property with the exact same name as the Car class */
@property (nonatomic, assign, readonly) NSInteger numberOfDoors;

- (void)setNumberOfDoors:(NSInteger)numberOfDoors;

@end
