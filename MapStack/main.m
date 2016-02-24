//
//  main.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

struct vanillaStruct {
    int anInteger;
    char *firstName;
};

int main(int argc, char * argv[]) {
    
    struct vanillaStruct valueType0;
    valueType0.anInteger = 7;
    valueType0.firstName = "mike";
    
    NSObject *objectType0 = [[NSObject alloc] init];
    [objectType0 setAccessibilityLabel:@"I'm a string"];
    
    struct vanillaStruct valueType1 = valueType0;
    NSObject *objectType1           = objectType0;
    
    printf("first names: %s, %s \n", valueType0.firstName, valueType1.firstName);
    printf("anIntegers: %d, %d \n", valueType0.anInteger, valueType1.anInteger);
    NSLog(@"accessibiltyLabels: %@ %@", objectType0.accessibilityLabel, objectType1.accessibilityLabel);
    
    valueType0.firstName = "mary";
    [objectType0 setAccessibilityLabel:@"I'm a different string"];
    
    printf("first names again: %s, %s \n", valueType0.firstName, valueType1.firstName);
    printf("anIntegers again: %d, %d \n", valueType0.anInteger, valueType1.anInteger);
    NSLog(@"accessibiltyLabels again: %@ %@", objectType0.accessibilityLabel, objectType1.accessibilityLabel);
    
    
    
    //    @autoreleasepool {
    //        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    //    }
}
