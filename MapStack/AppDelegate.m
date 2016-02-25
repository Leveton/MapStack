//
//  AppDelegate.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "LocationsViewController.h"
#import "FavoritesViewController.h"
#import "SettingsViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong, nullable) MapViewController       *mapViewController;
@property (nonatomic, strong, nullable) LocationsViewController *locationsViewController;
@property (nonatomic, strong, nullable) FavoritesViewController *favoritesViewController;
@property (nonatomic, strong, nullable) SettingsViewController  *settingsViewController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *controller = [[UITabBarController alloc]init];
    NSArray *controllers = [NSArray arrayWithObjects:[self mapViewController], [self locationsViewController], [self favoritesViewController], [self settingsViewController], nil];
    [controller setViewControllers:controllers];
    
    [[self window] setRootViewController:controller];
    [[self window] makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - getters

- (MapViewController *)mapViewController{
    if (!_mapViewController){
        _mapViewController = [[MapViewController alloc] init];
        [[_mapViewController view] setBackgroundColor:[UIColor redColor]];
        [[_mapViewController tabBarItem] setImage:[UIImage imageNamed:@"home"]];
        [[_mapViewController tabBarItem] setTag:0];
    }
    return _mapViewController;
}

- (LocationsViewController *)locationsViewController{
    if (!_locationsViewController){
        _locationsViewController = [[LocationsViewController alloc] init];
        [[_locationsViewController view] setBackgroundColor:[UIColor blueColor]];
        [[_locationsViewController tabBarItem] setImage:[UIImage imageNamed:@"table"]];
        [[_locationsViewController tabBarItem] setTag:1];
    }
    return _locationsViewController;
}

- (FavoritesViewController *)favoritesViewController{
    if (!_favoritesViewController){
        _favoritesViewController = [[FavoritesViewController alloc] init];
        [[_favoritesViewController view] setBackgroundColor:[UIColor greenColor]];
        [[_favoritesViewController tabBarItem] setImage:[UIImage imageNamed:@"favorites"]];
        [[_favoritesViewController tabBarItem] setTag:2];
    }
    return _favoritesViewController;
}

- (SettingsViewController *)settingsViewController{
    if (!_settingsViewController){
        _settingsViewController = [[SettingsViewController alloc] init];
        [[_settingsViewController view] setBackgroundColor:[UIColor yellowColor]];
        [[_settingsViewController tabBarItem] setImage:[UIImage imageNamed:@"settings"]];
        [[_settingsViewController tabBarItem] setTag:3];
    }
    return _settingsViewController;
}

@end
