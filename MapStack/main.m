//
//  main.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Car.h"

struct vanillaStruct {
    int   anInteger;
    char *firstName;
};

int main(int argc, char * argv[]) {
    
    /* this demo's reference vs value types using main() which the students are familiar with */
    struct vanillaStruct valueType0;
    valueType0.anInteger = 7;
    valueType0.firstName = "mike";
    
    Car *car0 = [[Car alloc] init];
    [car0 setNumberOfDoors:2];
    
    struct vanillaStruct valueType1 = valueType0;
    Car *car1                       = car0;
    
    printf("first names: %s, %s \n", valueType0.firstName, valueType1.firstName);
    printf("anIntegers: %d, %d \n", valueType0.anInteger, valueType1.anInteger);
    NSLog(@"car doors: %ld %ld", (long)car0.numberOfDoors, (long)car1.numberOfDoors);
    
    valueType0.firstName = "mary";
    [car0 setNumberOfDoors:4];
    
    printf("first names again: %s, %s \n", valueType0.firstName, valueType1.firstName);
    printf("anIntegers again: %d, %d \n", valueType0.anInteger, valueType1.anInteger);
    NSLog(@"car doors again: %ld %ld", (long)car0.numberOfDoors, (long)car1.numberOfDoors);
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
