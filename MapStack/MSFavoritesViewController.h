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
@property (nonatomic, strong, readonly) NSArray *favoritesOrder;

- (void)setDataSource:(NSArray *)dataSource;
- (void)setFavoritesOrder:(NSArray *)favoritesOrder;

@end
