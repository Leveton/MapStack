//
//  MSMapViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSMapViewController.h"

#define kLocStringHelloWorld          NSLocalizedString(@"Hello World", @"Hello World")
#define kLabelSide                    (200.0f)
#define kTabbarHeight                 (49.0f)
@interface MSMapViewController ()
@property (nonatomic, strong, nullable) UILabel *label;
@end

@implementation MSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    /* use 2 floats defined at the top to set the label's size (it's width and height) */
    CGRect labelFrame      = [[self label] frame];
    labelFrame.size        = CGSizeMake(kLabelSide, kLabelSide);
    
    /* Calculate the label's position of the view using Core Graphic helper methods */
    CGFloat xOffset        = (CGRectGetWidth([[self view] frame]) - kLabelSide)/2;
    CGFloat yOffset        = ((CGRectGetHeight([[self view] frame]) - kTabbarHeight) - kLabelSide)/2;
    CGPoint labelOrigin    = CGPointMake(xOffset, yOffset);
    labelFrame.origin      = labelOrigin;
    
    /* set the label's frame via message passing */
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