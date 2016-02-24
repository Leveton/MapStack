//
//  MapViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MapViewController.h"

#define kLocStringHelloWorld         NSLocalizedString(@"Hello World", @"Hello World")
#define kLabelSide                   (200.0f)
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
    
    CGRect labelFrame      = [[self label] frame];
    labelFrame.size.width  = kLabelSide;
    labelFrame.size.height = kLabelSide;
    labelFrame.origin.x = (CGRectGetWidth([[self view] frame]) - kLabelSide)/2;
    labelFrame.origin.y = (CGRectGetHeight([[self view] frame]) - kLabelSide)/2;
    [[self label] setFrame:labelFrame];
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
        [[_label layer] setBorderColor:_label.textColor.CGColor];
        [[_label layer] setBorderWidth:1.0f];
        [[self view] addSubview:_label];
    }
    return _label;
}


@end