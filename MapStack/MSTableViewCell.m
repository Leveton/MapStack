//
//  MSTableViewCell.m
//  MapStack
//
//  Created by Mike Leveton on 2/29/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSTableViewCell.h"

@interface MSTableViewCell()
@property (nonatomic, strong) UILabel     *mainLabel;
@property (nonatomic, strong) UILabel     *subLabel;
@property (nonatomic, strong) UIButton    *deleteButton;
@property (nonatomic, strong) UIButton    *detailsButton;
@property (nonatomic, strong) UIImageView *locationImageView;
@end

@implementation MSTableViewCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

#pragma mark - getters

- (UILabel *)mainLabel{
    if (!_mainLabel){
        _mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_mainLabel];
        return _mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)subLabel{
    if (!_subLabel){
        _subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self addSubview:_subLabel];
        return _subLabel;
    }
    return _subLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton){
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_deleteButton];
        return _deleteButton;
    }
    return _deleteButton;
}

- (UIButton *)detailsButton{
    if (!_detailsButton){
        _detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self addSubview:_detailsButton];
        return _detailsButton;
    }
    return _detailsButton;
}

- (UIImageView *)locationImageView{
    if (!_locationImageView){
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_locationImageView];
        return _locationImageView;
    }
    return _locationImageView;
}

#pragma mark - setters

- (void)setLocation:(MSLocation *)location{
    _location = location;
    
    [[self mainLabel] setText:[_location title]];
    [[self subLabel] setText:[_location subtitle]];
    
    if ([_location locationImage]){
        [[self locationImageView] setImage:[_location locationImage]];
        [[self locationImageView] sizeToFit];
    }
}

@end
