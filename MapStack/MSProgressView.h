//
//  MSProgressView.h
//  MapStack
//
//  Created by Mike Leveton on 3/3/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSProgressView : UIView

/* we'll make it public so that owning classes can unhide and trigger it */
@property (nonatomic, strong, nullable) UIActivityIndicatorView *progressView;
@end
