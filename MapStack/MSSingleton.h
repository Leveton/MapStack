//
//  MSSingleton.h
//  MapStack
//
//  Created by Mike Leveton on 2/27/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MSSingleton : NSObject

/* a global that's an object should be checked for existence before use */
@property (nonatomic, strong) UIColor *themeColor;

+ (MSSingleton *)sharedSingleton;
@end
