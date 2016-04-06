//
//  MSLocationDetailViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocationDetailViewController.h"

@interface MSLocationDetailViewController ()
@property (nonatomic, strong, nullable) UILabel *label;
@end

@implementation MSLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor redColor]];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [[self label] setFrame:[[self view] frame]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

- (UILabel *)label{
    if (!_label){
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [[self view] addSubview:_label];
    }
    return _label;
}

#pragma mark - setters

/* this gets called before the view lifecycle is started */
- (void)setLocation:(MSLocation *)location{
    _location = location;
    [[self label] setText:[_location title]];
}

@end
