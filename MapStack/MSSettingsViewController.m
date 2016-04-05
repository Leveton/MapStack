//
//  MSSettingsViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSSettingsViewController.h"

@interface MSSettingsViewController ()

@end

@implementation MSSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
