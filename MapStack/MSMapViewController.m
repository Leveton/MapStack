//
//  MSMapViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocation.h"
#import "MSMapViewController.h"
#import "MSLocationsViewController.h"

#import <MapKit/MapKit.h>

#define kMapSide                     (300.0f)
#define kTabbarHeight                (49.0f)

@interface MSMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong, nonnull) MKMapView                     *map;
@property (nonatomic, strong, nullable) CLLocationManager            *manager;
@property (nonatomic, assign) CLLocationCoordinate2D                 centerPoint;
@property (nonatomic, strong, nullable) NSMutableArray<MSLocation *> *dataSource;
@end

@implementation MSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* listen for a notification that the app's theme color changed */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeColorChanged:) name:@"com.mapstack.userDidChangeTheme" object:nil];
    
    /* get the user's current location */
    [[self manager] startUpdatingLocation];
    
    MKCoordinateRegion adjustedRegion = [[self map] regionThatFits:MKCoordinateRegionMakeWithDistance([self centerPoint], 1600, 1600)];
    [[self map] setRegion:adjustedRegion animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self populateMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

- (MKMapView *)map{
    if (!_map){
        
        /* MKMapView is a subclass of UIView, all UIView's can be initialized with a frame */
        _map = [[MKMapView alloc]initWithFrame:[self mapFrame]];
        [_map setDelegate:self];
        [_map setShowsUserLocation:YES];
        [[self view] addSubview:_map];
    }
    return _map;
}

- (CGRect)mapFrame{
    
    /* use 2 floats defined at the top to set the map's size (it's width and height) */
    CGRect mapFrame        = CGRectZero;
    mapFrame.size          = CGSizeMake(kMapSide, kMapSide);
    
    /* Calculate the map's position of the view using Core Graphic helper methods */
    CGFloat xOffset        = (CGRectGetWidth([[self view] frame]) - kMapSide)/2;
    CGFloat yOffset        = ((CGRectGetHeight([[self view] frame]) - kTabbarHeight) - kMapSide)/2;
    CGPoint mapOrigin      = CGPointMake(xOffset, yOffset);
    mapFrame.origin        = mapOrigin;
    
    return  mapFrame;
}

- (CLLocationManager *)manager{
    if (!_manager){
        _manager = [[CLLocationManager alloc]init];
        [_manager requestWhenInUseAuthorization];
        [_manager setDelegate:self];
    }
    return _manager;
}

- (CLLocationCoordinate2D)centerPoint{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude  = 25.777599;
    coordinate.longitude = -80.190793;
    return coordinate;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - selectors

/* implement the selector or your app will crash if this object receives a userDidChangeTheme notification */
- (void)themeColorChanged:(NSNotification *)notification{
}

- (void)populateMap{
    
    /* clear the current data sourcev */
    [[self dataSource] removeAllObjects];
    
    /**
     grab the local json file
     */
    NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"MapStackLocations" ofType:@"json"];
    /**
     convert it to bytes
     */
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile];
    
    /**
     convert the bytes to json
     */
    NSError *error;
    id jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error){
        NSLog(@"json error: %@", error.description);
        return;
    }
    
    NSArray *locationDictionaries = [jsonResponse objectForKey:@"MapStackLocationsArray"];
    
    /* Create a mapstacklocation object for each json object. Use fast enumeration here instead of a for loop. it's a touch slower but safer */
    [locationDictionaries enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        
        [[self dataSource] addObject:[self createLocationWithDictionary:item]];
    }];
    
    /**
     get the reference to locations view controller and set its datasource
     */
    NSArray *viewControllers = [[self tabBarController] viewControllers];
    MSLocationsViewController *vc = [viewControllers objectAtIndex:1];
    [vc setDataSource:[self dataSource]];
    
}

- (MSLocation *)createLocationWithDictionary:(NSDictionary *)dict{
    
    /* map the JSON to a MapStackLocation object that we can then use all over our project */
    MSLocation *location = [[MSLocation alloc]init];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude  = [[dict objectForKey:@"latitude"] floatValue];
    coordinate.longitude = [[dict objectForKey:@"longitude"] floatValue];
    location.coordinate  = coordinate;
    
    [location setTitle:[dict objectForKey:@"name"]];
    [location setType:[dict objectForKey:@"type"]];
    [location setCoordinate:coordinate];
    [location setDistance:[[dict objectForKey:@"distance"] floatValue]];
    
    UIImage *image = [UIImage imageNamed:[dict objectForKey:@"image"]];
    [location setLocationImage:image];
    
    [[self map] addAnnotation:location];
    
    return location;
}


#pragma mark - MKMapViewDelegate

#pragma mark - CLLocationManagerDelegate

@end