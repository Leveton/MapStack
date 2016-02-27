//
//  MSMapViewController.H
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSMapViewController : UIViewController

/* expose the method that annotates the map in case another class gets the data  */
- (void)populateMap;
@end
