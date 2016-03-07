//
//  MSLocationDetailViewController.h
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLocationDetailViewController : UIViewController

@property (nonatomic, strong, readonly) MSLocation *location;
@property (nonatomic, assign, readonly) BOOL       isViewPresented;

- (void)setLocation:(MSLocation *)location;
- (void)setIsViewPresented:(BOOL)isViewPresented;
@end
