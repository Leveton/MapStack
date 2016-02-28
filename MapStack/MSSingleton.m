//
//  MSSingleton.m
//  MapStack
//
//  Created by Mike Leveton on 2/27/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSSingleton.h"


@interface MSSingleton()
@end

@implementation MSSingleton


static MSSingleton *_sharedSingleton = nil;

+ (MSSingleton *)sharedSingleton
{
    static dispatch_once_t pred;
    static MSSingleton *instance = nil;
    dispatch_once(&pred, ^{instance = [[self alloc]init];});
    return instance;
}

+ (id)alloc
{
    @synchronized([MSSingleton class])
    {
        NSAssert(_sharedSingleton == nil, @"Attempted to allocate a second instance of a singleton.");
        _sharedSingleton = [super alloc];
        return _sharedSingleton;
    }
    
    return nil;
}

@end

