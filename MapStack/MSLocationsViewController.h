//
//  MSLocationsViewController.h
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSRange.h"

@interface MSLocationsViewController : UIViewController

@property (nonatomic, strong, readonly) NSArray   *dataSource;
@property (nonatomic, strong, readonly) MSRange   *range;

- (void)setDataSource:(NSArray *)dataSource;
- (void)setRange:(MSRange *)range;
@end
