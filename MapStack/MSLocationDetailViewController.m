//
//  MSLocationDetailViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocationDetailViewController.h"

@interface MSLocationDetailViewController ()

@end

@implementation MSLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setters

/* this gets called before the view lifecycle is started */
- (void)setLocation:(MSLocation *)location{
    _location = location;
}

@end
