//
//  MSFavoritesViewController.h
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFavoritesViewController : UIViewController

@property (nonatomic, strong, readonly) NSArray *dataSource;

- (void)setDataSource:(NSArray *)dataSource;

@end
