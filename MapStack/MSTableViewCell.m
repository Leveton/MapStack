//
//  MSTableViewCell.m
//  MapStack
//
//  Created by Mike Leveton on 2/29/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSTableViewCell.h"

@interface MSTableViewCell()
@property (nonatomic, strong, nullable) UILabel     *mainLabel;
@property (nonatomic, strong, nullable) UILabel     *subLabel;
@property (nonatomic, strong, nullable) UIButton    *deleteButton;
@property (nonatomic, strong, nullable) UIButton    *detailsButton;
@property (nonatomic, strong, nullable) UIImageView *locationImageView;
@property (nonatomic, strong, nullable) UIView      *dividerLine;
@end

@implementation MSTableViewCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat viewHeight       = CGRectGetHeight([self frame]);
    
    /*we'll use the imageView, who's bounds is set with sizeToFit, to dictate the rest of our layout */
    CGRect imageFrame        = [[self locationImageView] frame];
    imageFrame.size.width    = viewHeight;
    imageFrame.size.height   = viewHeight;
    imageFrame.origin.x      = CGRectGetWidth([self frame]) - imageFrame.size.width;
    
    /*custom method that centers a view vertically */
    imageFrame.origin.y      = [self verticallyCenteredFrameForChildFrame:imageFrame].origin.y;
    [[self locationImageView] setFrame:imageFrame];
    
    CGRect detailsFrame      = [[self detailsButton] frame];
    detailsFrame.size.width  = (CGRectGetWidth([self frame]) - imageFrame.size.width)/2;
    detailsFrame.size.height = viewHeight/2;
    detailsFrame.origin.x    = imageFrame.origin.x - detailsFrame.size.width;
    /* the origin is 0,0 by default so no need to set it */
    [[self detailsButton] setFrame:detailsFrame];
    
    CGRect deleteFrame      = [[self deleteButton] frame];
    deleteFrame.size.width  = (CGRectGetWidth([self frame]) - imageFrame.size.width)/2;
    deleteFrame.size.height = viewHeight/2;
    deleteFrame.origin.x    = imageFrame.origin.x - detailsFrame.size.width;
    deleteFrame.origin.y    = viewHeight/2;
    [[self deleteButton] setFrame:deleteFrame];
    
    CGRect mainFrame        = [[self mainLabel] frame];
    mainFrame.size.width    = (CGRectGetWidth([self frame]) - imageFrame.size.width)/2;
    mainFrame.size.height   = viewHeight/2;
    /* the origin is 0,0 by default so no need to set it */
    [[self mainLabel] setFrame:mainFrame];
    
    CGRect subFrame         = [[self subLabel] frame];
    subFrame.size.width     = (CGRectGetWidth([self frame]) - imageFrame.size.width)/2;
    subFrame.size.height    = viewHeight/2;
    subFrame.origin.y       = viewHeight/2;
    /* the origin is 0,0 by default so no need to set it */
    [[self subLabel] setFrame:subFrame];
    
    /*good example of not just thinking of UIViews as squares but as lines or even circles */
    CGRect dividerFrame     = [[self dividerLine] frame];
    dividerFrame.size.width = imageFrame.origin.x;
    dividerFrame.size.height= 1.0f;
    dividerFrame.origin.y   = viewHeight - 1.0f;
    [[self dividerLine] setFrame:dividerFrame];
    
}

#pragma mark - getters

- (UILabel *)mainLabel{
    if (!_mainLabel){
        _mainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        /*distinguish with background color */
        [_mainLabel setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:234.0/255.0 alpha:1.0f]];

        [self addSubview:_mainLabel];
        return _mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)subLabel{
    if (!_subLabel){
        _subLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        /* set a custom font */
        [_subLabel setFont:[UIFont fontWithName:@"Chalkduster" size:12.0f]];
        
        /*distinguish with background color */
        [_subLabel setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:234.0/255.0 alpha:1.0f]];
        
        [self addSubview:_subLabel];
        return _subLabel;
    }
    return _subLabel;
}

- (UIButton *)deleteButton{
    if (!_deleteButton){
        _deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f]];
        [[_deleteButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
        
        /*set the opacity and the background color to demo Instruments graphics profiling */
        [[_deleteButton titleLabel] setOpaque:YES];
        [[_deleteButton titleLabel] setBackgroundColor:[_deleteButton backgroundColor]];
        
        [_deleteButton setTitle:NSLocalizedString(@"Delete", nil) forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didTapDelete:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        return _deleteButton;
        
    }
    return _deleteButton;
}

- (UIButton *)detailsButton{
    if (!_detailsButton){
        _detailsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_detailsButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_detailsButton setBackgroundColor:[UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0f]];
        [[_detailsButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
        
        /*set the opacity and the background color to demo Instruments graphics profiling */
        [[_detailsButton titleLabel] setOpaque:YES];
        [[_detailsButton titleLabel] setBackgroundColor:[_detailsButton backgroundColor]];
        
        [_detailsButton setTitle:NSLocalizedString(@"Details", nil) forState:UIControlStateNormal];
        [_detailsButton addTarget:self action:@selector(didTapDetail:) forControlEvents:UIControlEventTouchUpInside];
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

- (UIView *)dividerLine{
    if (!_dividerLine){
        _dividerLine = [[UIView alloc] initWithFrame:CGRectZero];
        
        /*don't use black in a real project. google the reason why */
        [_dividerLine setBackgroundColor:[UIColor blackColor]];
        
        /* set its y index to be greater than the other subviews on the cell */
        [[_dividerLine layer] setZPosition:2.0f];
        
        [self addSubview:_dividerLine];
        return _dividerLine;
    }
    return _dividerLine;
}


#pragma mark - setters

- (void)setLocation:(MSLocation *)location{
    _location = location;
    
    [[self mainLabel] setText:[_location title]];
    [[self subLabel] setText:[_location type]];
    
    if ([_location locationImage]){
        [[self locationImageView] setImage:[_location locationImage]];
    }
}

#pragma mark - selectors

- (void)didTapDelete:(id)sender{
    if ([[self delegate] respondsToSelector:@selector(deleteButtonTappedFromCell:)]){
        
        /*always create delegates that allow you to pass a reference to self */
        [[self delegate] deleteButtonTappedFromCell:self];
    }
}

- (void)didTapDetail:(id)sender{
    if ([[self delegate] respondsToSelector:@selector(detailsButtonTappedFromCell:)]){
        
        /*always create delegates that allow you to pass a reference to self */
        [[self delegate] detailsButtonTappedFromCell:self];
    }
}

@end
