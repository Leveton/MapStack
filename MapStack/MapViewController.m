//
//  MapViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MapViewController.h"

#define kLocStringHelloWorld         NSLocalizedString(@"Hello World", @"Hello World")

@interface MapViewController ()
@property (nonatomic, strong, nullable) UILabel *label;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - gettters

- (UILabel *)label{
    if (!_label){
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        [_label setText:kLocStringHelloWorld];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [[self view] addSubview:_label];
    }
    return _label;
}


@end
