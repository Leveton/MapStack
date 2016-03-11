//
//  MapStackTests.m
//  MapStackTests
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MSLocation.h"

@interface MapStackTests : XCTestCase
@property (nonatomic, strong) MSLocation *location;
@end

@implementation MapStackTests

- (void)setUp {
    [super setUp];
    _location = [[MSLocation alloc]init];
    [_location setTitle:@"Miami"];
    [_location setType:@"City"];
    [_location setLocationId:2];
    [_location setDistance:1000];
    [_location setFavoritesOrder:3];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude  = 0.88f;
    coordinate.longitude = 0.54f;
    [_location setCoordinate:coordinate];
    UIImage *image = [UIImage imageNamed:@"favoriteStar"];
    [_location setLocationImage:image];
}

- (void)tearDown {
    [super tearDown];
    _location = nil;
}

- (void)testLocationValues {
    XCTAssertEqualObjects([[self location] title], @"Miami");
    XCTAssertEqualObjects([[self location] type], @"City");
    XCTAssertEqualObjects([[self location] locationImage], [UIImage imageNamed:@"favoriteStar"]);
}

- (void)testLocationProperties {
    XCTAssertNotNil([[self location] title]);
    XCTAssertNotNil([[self location] type]);
    XCTAssertNotNil([[self location] locationImage]);
    
    /* use introspection here */
    XCTAssert([[[self location] title] isKindOfClass:[NSString class]]);
    XCTAssert([[[self location] type] isKindOfClass:[NSString class]]);
    XCTAssert([[[self location] locationImage] isKindOfClass:[UIImage class]]);
}

- (void)testPerformanceExample {
    
    CLLocationCoordinate2D startPoint;
    startPoint.latitude  = 25.8011413f;
    startPoint.longitude = -80.2022127f;
    
    CLLocationCoordinate2D endPoint;
    endPoint.latitude  = 25.7776625f;
    endPoint.longitude = -80.190763;
    
    // This is an example of a performance test case. It will run the code in the block 10 times and then print out stats such as mean.
    [self measureBlock:^{
        double distance = [_location getDistanceFromPoint:startPoint toPoint:endPoint];
        [_location setDistance:distance];
    }];
}

@end
