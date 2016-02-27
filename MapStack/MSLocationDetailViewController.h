//
//  MSLocationDetailViewController.h
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"

@interface MSLocationDetailViewController : UIViewController

@property (nonatomic, strong, readonly) MSLocation *location;

- (void)setLocation:(MSLocation *)location;
@end
