//
//  MSSettingsViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSSettingsViewController.h"
#import "MSSingleton.h"

typedef enum NSInteger {
    kThemeColor,
    kTypeFilter,
    kLocation
}sectionHeaders;

@interface MSSettingsViewController ()

@end

@implementation MSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* make sure the global theme color has been set */
    if ([MSSingleton sharedSingleton].themeColor) {
        [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    }else{
        [[self view] setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - computed properties

- (NSString *)userFirstName{
    /* save the user's name for access in other classes */
    NSString *name = @"Mike";
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"com.mapstack.primaryCarUser"];
    
    /* access this in other classes */
    NSString *nameAgain = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.mapstack.primaryCarUser"];
    return nameAgain;
}

@end
