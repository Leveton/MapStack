//
//  AppDelegate.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "AppDelegate.h"
#import "MSMapViewController.h"
#import "MSLocationsViewController.h"
#import "MSFavoritesViewController.h"
#import "MSSettingsViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong, nullable) MSMapViewController       *mapViewController;
@property (nonatomic, strong, nullable) MSLocationsViewController *locationsViewController;
@property (nonatomic, strong, nullable) MSFavoritesViewController *favoritesViewController;
@property (nonatomic, strong, nullable) MSSettingsViewController  *settingsViewController;
@property (nonatomic, strong, nullable) UIColor                   *themeColor;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self themeColor];
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

- (MSMapViewController *)mapViewController{
    if (!_mapViewController){
        _mapViewController = [[MSMapViewController alloc] init];
        [[_mapViewController view] setBackgroundColor:[self themeColor]];
        [[_mapViewController tabBarItem] setImage:[UIImage imageNamed:@"home"]];
        [[_mapViewController tabBarItem] setTag:0];
    }
    return _mapViewController;
}

- (MSLocationsViewController *)locationsViewController{
    if (!_locationsViewController){
        _locationsViewController = [[MSLocationsViewController alloc] init];
        [[_locationsViewController view] setBackgroundColor:[self themeColor]];
        [[_locationsViewController tabBarItem] setImage:[UIImage imageNamed:@"table"]];
        [[_locationsViewController tabBarItem] setTag:1];
    }
    return _locationsViewController;
}

- (MSFavoritesViewController *)favoritesViewController{
    if (!_favoritesViewController){
        _favoritesViewController = [[MSFavoritesViewController alloc] init];
        [[_favoritesViewController view] setBackgroundColor:[self themeColor]];
        [[_favoritesViewController tabBarItem] setImage:[UIImage imageNamed:@"favorites"]];
        [[_favoritesViewController tabBarItem] setTag:2];
    }
    return _favoritesViewController;
}

- (MSSettingsViewController *)settingsViewController{
    if (!_settingsViewController){
        _settingsViewController = [[MSSettingsViewController alloc] init];
        [[_settingsViewController view] setBackgroundColor:[self themeColor]];
        [[_settingsViewController tabBarItem] setImage:[UIImage imageNamed:@"settings"]];
        [[_settingsViewController tabBarItem] setTag:3];
    }
    return _settingsViewController;
}

- (UIColor *)themeColor{
    if (!_themeColor){
        _themeColor = [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];
    }
    return _themeColor;
}

@end
