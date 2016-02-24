//
//  Honda.m
//  MapStack
//
//  Created by Mike Leveton on 2/24/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "Honda.h"

@implementation Honda

- (void)setModel:(ModelType)model{
    _model = model;
    
    /* dot notation must be used for child classes */
    if (_model == kModelTypePrelude){
        self.numberOfDoors = 2;
    }else{
        self.numberOfDoors = 4;
    }
}

@end
