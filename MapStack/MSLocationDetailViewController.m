//
//  MSLocationDetailViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/26/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocationDetailViewController.h"
#import "AppDelegate.h"

#define kViewMargin           (10.0f)
#define kImageHeight          (245.0f)
#define kLabelHeight          (50.0f)
#define kAnimationHeight      (20.0f)

@interface MSLocationDetailViewController ()
@property (nonatomic, strong) UILabel                *label;
@property (nonatomic, strong) UILabel                *distanceLabel;
@property (nonatomic, strong) UIButton               *dismissButton;
@property (nonatomic, strong) UIButton               *favoriteButton;
@property (nonatomic, strong) UIImageView            *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) BOOL                   isLocationFavorited;
@end

@implementation MSLocationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* make sure the global theme color has been set */
    if ([MSSingleton sharedSingleton].themeColor) {
        [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    }else{
        [[self view] setBackgroundColor:[UIColor whiteColor]];
    }
    
    /* determine if this location has been favorited */
    NSInteger locationId = [_location locationId];
    NSArray *favorites   = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesArray"];
    
    /* another example of a block, unlike with animations, the code is executed imediately before the method returns */
    [favorites enumerateObjectsUsingBlock:^(NSNumber *item, NSUInteger idx, BOOL *stop) {
        
        if ([item integerValue] == locationId){
            _isLocationFavorited = YES;
            *stop = YES;
        }
    }];
    
    if (_isLocationFavorited){
        [[self favoriteButton] setImage:[UIImage imageNamed:@"favoriteStar"] forState:UIControlStateNormal];
    }else{
        [[self favoriteButton] setImage:[UIImage imageNamed:@"favoriteStarEmpty"] forState:UIControlStateNormal];
    }
    
    [[self favoriteButton] sizeToFit];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect imageFrame     = [[self imageView] frame];
    imageFrame.origin.x   = kViewMargin;
    
    /* the status bar is 20 points, the navbar (if exists) is 44 */
    CGFloat navHeight = _isViewPresented ? 20.0f : 64.0f;
    
    imageFrame.origin.y   = (kViewMargin * 2) + navHeight;
    imageFrame.size.width = CGRectGetWidth([[self view] frame]) - (kViewMargin *2);
    imageFrame.size.height= kImageHeight;
    [[self imageView] setFrame:imageFrame];
    
    CGRect labelFrame     = [[self label] frame];
    labelFrame.origin.x   = kViewMargin;
    
    /* a core graphic helper method that gets the y-offset + the height */
    labelFrame.origin.y   = CGRectGetMaxY(imageFrame);
    
    labelFrame.size.width = CGRectGetWidth([[self view] frame]) - (kViewMargin * 2);
    labelFrame.size.height= kLabelHeight;
    [[self label] setFrame:labelFrame];
    
    CGRect distanceLabelFrame     = [[self distanceLabel] frame];
    distanceLabelFrame.origin.x   = kViewMargin;
    distanceLabelFrame.origin.y   = CGRectGetMaxY(labelFrame);
    distanceLabelFrame.size.width = CGRectGetWidth([[self view] frame]) - (kViewMargin * 2);
    distanceLabelFrame.size.height= kLabelHeight;
    [[self distanceLabel] setFrame:distanceLabelFrame];
    
    if (_isViewPresented){
        CGRect dismissFrame   = [[self dismissButton] frame];
        dismissFrame.origin.x = kViewMargin;
        
        /* the status bar is 20 points, the navbar (if exists) is 44 */
        dismissFrame.origin.y = _isViewPresented ? 20.0f : 64.0f;
        
        [[self dismissButton] setFrame:dismissFrame];
    }
    
    CGRect favoriteFrame   = [[self favoriteButton] frame];
    favoriteFrame.origin.x = CGRectGetWidth([[self view] frame]) - (favoriteFrame.size.width + kViewMargin);
    
    /* the status bar is 20 points, the navbar (if exists) is 44 */
    favoriteFrame.origin.y = _isViewPresented ? 20.0f : 64.0f;
    
    [[self favoriteButton] setFrame:favoriteFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* hides the tabbar if it's pushed onto the stack */
- (BOOL)hidesBottomBarWhenPushed{
    return YES;
}

#pragma mark - getters

- (UILabel *)label{
    if (!_label){
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        
        /* create a border for our viewv*/
        [[_label layer] setBorderWidth:1.0f];
        
        /* we must set this to true in order for it to receive the tap gesture */
        [_label setUserInteractionEnabled:YES];
        [_label addGestureRecognizer:[self tap]];
        
        [_label setTextAlignment:NSTextAlignmentCenter];
        [[self view] addSubview:_label];
    }
    return _label;
}

- (UILabel *)distanceLabel{
    if (!_distanceLabel){
        _distanceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [[_distanceLabel layer] setBorderWidth:1.0f];
        
        /* hide the label by default, our tap gesture will reveal it */
        [_distanceLabel setHidden:YES];
        
        [_distanceLabel setTextAlignment:NSTextAlignmentCenter];
        [[self view] addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (UIButton *)dismissButton{
    if (!_dismissButton){
        /* using UIButtonTypeSystem causes UIKit to give us some nice things. Research it */
        _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_dismissButton setFrame:CGRectZero];
        
        [_dismissButton setImage:[UIImage imageNamed:@"dismissButton"] forState:UIControlStateNormal];
        
        /* stretches the bounds of the frame to accomodate the image size */
        [_dismissButton sizeToFit];
        
        
        [_dismissButton addGestureRecognizer:[self pan]];
        
        /* Make the button do something. Notice the 'TouchUpInside' enum */
        [_dismissButton addTarget:self action:@selector(didTapDismiss:) forControlEvents:UIControlEventTouchUpInside];
        
        /* only show dismiss button if view is modal */
        if (_isViewPresented){
          [[self view] addSubview:_dismissButton];
        }
    }
    return _dismissButton;
}

- (UIButton *)favoriteButton{
    if (!_favoriteButton){
        
        _favoriteButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_favoriteButton setFrame:CGRectZero];;
        
        [_favoriteButton addTarget:self action:@selector(didTapFavorite:) forControlEvents:UIControlEventTouchUpInside];
        [[self view] addSubview:_favoriteButton];
    }
    return _favoriteButton;
}

- (UITapGestureRecognizer *)tap{
    if (!_tap){
        
        /*custom init method */
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapLabel:)];
        
        /* force users to double tap */
        [_tap setNumberOfTapsRequired:2];
    }
    return _tap;
}

- (UIPanGestureRecognizer *)pan{
    if (!_pan){
        
        /*custom init method */
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanImageView:)];
    }
    return _pan;
}


- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [[self view] addSubview:_imageView];
    }
    return _imageView;
}



#pragma mark - setters

/* this gets called before the view lifecycle is started */
- (void)setLocation:(MSLocation *)location{
    _location = location;
    [[self label] setText:[_location title]];
    [[self distanceLabel] setText:[NSString stringWithFormat:@"distance: %ld meters", (long)[_location distance]]];
    [[self imageView] setImage:[_location locationImage]];
}

- (void)setIsViewPresented:(BOOL)isViewPresented{
    _isViewPresented = isViewPresented;
}

#pragma mark - selectors

/* uncomment this to show exampple of block variable used in place of an inline block */

//void(^handleViewDismiss)(void) = ^{
//    NSLog(@"completion block fired!");
//};
//
//- (void)didTapDismiss:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:handleViewDismiss];
//    NSLog(@"reached end of didTapDismiss scope");
//}


- (void)didTapDismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"completion block fired!");
    }];
    
    NSLog(@"reached end of didTapDismiss scope");
}

- (void)didTapLabel:(UITapGestureRecognizer *)tapRecognizer{
    
    /*toggle the label as hidden or not */
    [[self distanceLabel] setHidden:![[self distanceLabel] isHidden]];
    
    [self animateDistanceLabel];
    
}

- (void)didTapFavorite:(id)sender{
    
    /*let's prevent interaction until the method returns */
    [sender setEnabled:NO];
    
    [sender setImage:_isLocationFavorited ? [UIImage imageNamed:@"favoriteStarEmpty"] :[UIImage imageNamed:@"favoriteStar"] forState:UIControlStateNormal];
    
    
    NSNumber *locationId = [NSNumber numberWithInteger:[_location locationId]];
    NSArray *favs = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesArray"];
    
    /* one of several mutable array convenience initializers */
    NSMutableArray *mutableFavs = [NSMutableArray arrayWithArray:favs];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (_isLocationFavorited){
        [mutableFavs removeObject:locationId];
        [delegate removeLocationFromFavoritesWithLocation:_location];
        
    }else{
        [mutableFavs addObject:locationId];
        [delegate addLocationToFavoritesWithLocation:_location];
    }
    
    /* standard hack to prevent duplicates, by filtering the array through a set, all duplicates are removed because set elements must be unique */
    NSSet *set = [NSSet setWithArray:mutableFavs];
    favs = [set allObjects];
    
    [[NSUserDefaults standardUserDefaults] setObject:favs forKey:@"favoritesArray"];
    _isLocationFavorited = !_isLocationFavorited;
    [sender setEnabled:YES];
    
}

- (void)didPanImageView:(UIPanGestureRecognizer *)panRecongnizer{
    
    /* some ugly Objective-C syntax here ;) but we'll stay away from dot notation as promised */
    [[panRecongnizer view] setCenter:[panRecongnizer locationInView:[[panRecongnizer view] superview]]];
}

- (void)animateDistanceLabel{
    
        /* ensure that the user cannot rapidly hide and unhide the label */
        [[self label] setUserInteractionEnabled:NO];
    
        CGRect frame    = [[self distanceLabel] frame];
        CGFloat yOffset = [[self distanceLabel] isHidden] ? -kAnimationHeight : kAnimationHeight;
        frame.origin.y  = frame.origin.y + yOffset;
    
        [UIView animateWithDuration:0.3f
                              delay:0.1f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [[self distanceLabel] setFrame:frame];
                         }
                         completion:^(BOOL finished) {
    
                             /* animation complete. allow the user to toggle the label */
                             [[self label] setUserInteractionEnabled:YES];
    
                         }];
}

@end
