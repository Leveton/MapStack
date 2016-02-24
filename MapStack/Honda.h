//
//  Honda.h
//  MapStack
//
//  Created by Mike Leveton on 2/24/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

/* use this class do demo how a Honda object inherits numberOfDoors from Car but not numberOfWindows */
#import "Car.h"

/* familiar enum from CS50 */
typedef enum : NSUInteger {
    kModelTypeCivic,
    kModelTypeAccord,
    kModelTypePrelude
}ModelType;

@interface Honda : Car

/* we can still make our own types just like in C. Objective-C is just a superset of C */
@property (nonatomic, assign, readonly) ModelType model;

- (void)setModel:(ModelType)model;
@end
