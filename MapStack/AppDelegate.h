//
//  AppDelegate.h
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)addLocationToFavoritesWithLocation:(MSLocation *)location;
- (void)removeLocationFromFavoritesWithLocation:(MSLocation *)location;
@end

