//
//  MSTableViewCell.h
//  MapStack
//
//  Created by Mike Leveton on 2/29/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSLocation.h"

@protocol MSTableViewCellDelegate;

@interface MSTableViewCell : UITableViewCell
@property (nonatomic, weak) id <MSTableViewCellDelegate> delegate;
@property (nonatomic, strong, readonly) MSLocation *location;

- (void)setLocation:(MSLocation *)location;
@end

@protocol MSTableViewCellDelegate <NSObject>

@optional

- (void)deleteButtonTappedFromCell:(MSTableViewCell *)cell;
- (void)detailsButtonTappedFromCell:(MSTableViewCell *)cell;

@end
