//
//  MSMapViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocation.h"
#import "MSSingleton.h"
#import "MSMapViewController.h"
#import "MSLocationsViewController.h"
#import "MSFavoritesViewController.h"

#import <MapKit/MapKit.h>

#define kMapSide                     (300.0f)
#define kTabbarHeight                (49.0f)

@interface MSMapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>
@property (nonatomic, strong, nonnull) MKMapView                     *map;
@property (nonatomic, strong, nullable) CLLocationManager            *manager;
@property (nonatomic, assign) CLLocationCoordinate2D                 centerPoint;
@property (nonatomic, strong, nullable) NSMutableArray<MSLocation *> *dataSource;
@property (nonatomic, strong, nullable) NSMutableURLRequest          *locationsRequest;
@property (nonatomic, strong, nullable) NSURLSession                 *sessionLocations;
@end

@implementation MSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* listen for a notification that the app's theme color changed */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeColorChanged:) name:@"com.mapstack.userDidChangeTheme" object:nil];
    
    /* make sure the global theme color has been set */
    if ([MSSingleton sharedSingleton].themeColor) {
        [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    }else{
        [[self view] setBackgroundColor:[UIColor whiteColor]];
    }
    
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

- (NSMutableURLRequest *)locationsRequest{
    if (!_locationsRequest){
        
        /**
         As of iOS 9, apple requires that API endpoint use SSL. Were I to server this API via HTTP, the download would fail unless you executed a specific hack (Google app transport security for details on this).
         */
        
         NSURL *url = [NSURL URLWithString:@"http://mikeleveton.com/MapStackLocations.json"];
        _locationsRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    }
    return _locationsRequest;
}

/* NSURLSession is a large and rich API for downloading data */
- (NSURLSession *)sessionLocations{
    if (!_sessionLocations){
        
        /**
         use the default session configuration because we want the code executed immediately (not on a background thread like backgroundSessionConfigurationWithIdentifier), and, because the data's not sensitive, we want it to be cached (which ephemeral session doesn't do)
         */
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionLocations                 = [NSURLSession sessionWithConfiguration:config];
    }
    return _sessionLocations;
}


#pragma mark - selectors

/* implement the selector or your app will crash if this object receives a userDidChangeTheme notification */
- (void)themeColorChanged:(NSNotification *)notification{
}

- (void)populateMap{

    
    /* NSURLSessionDataTask returns data directly to the app in a block. This time, the block is exectuted when the response comes from the server */
    
    NSURLSessionDataTask *locationTask = [[self sessionLocations] dataTaskWithRequest:[self locationsRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        
        if (!error){
            NSError *JSONSerializationError;
            
            /** convert raw bytes to JSON */
            id jsonResponse = [NSJSONSerialization
                               JSONObjectWithData:data
                               options:NSJSONReadingMutableContainers
                               error:&JSONSerializationError]; //dereference the object before passing it. look this up.
            
            if (JSONSerializationError){
                NSLog(@"JSON error: %@", JSONSerializationError.description);
                [locationTask cancel];
                [self getLocalData];
                return;
            }
            
            /* clear the current data sourcev */
            [[self dataSource] removeAllObjects];
            NSLog(@"jsonResponse: %@", jsonResponse);
            [self layoutMapWithDictionary:jsonResponse];
            
        }else{
            [locationTask cancel];
            [self getLocalData];
            return;
        }
    }];
    
    [locationTask resume];
}

- (void)getLocalData{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /* clear the current data sourcev */
        [[self dataSource] removeAllObjects];
        
        /** grab the local json file */
        NSString *jsonFile = [[NSBundle mainBundle] pathForResource:@"MapStackLocations" ofType:@"json"];
        
        /**convert it to bytes*/
        NSData *jsonData = [NSData dataWithContentsOfFile:jsonFile];
        
        /** serialize the bytes into a dictionary object */
        NSError *error;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        if (error){
            NSLog(@"json error: %@", error.description);
            return;
        }
        
        [self layoutMapWithDictionary:jsonResponse];
    });
}

- (void)layoutMapWithDictionary:(NSDictionary *)dictionary{
    
    NSArray *locationDictionaries = [dictionary objectForKey:@"MapStackLocationsArray"];
    NSArray *favs                 = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesArray"];
    NSMutableArray *mutableFavs   = [[NSMutableArray alloc]init];
    /* Create a mapstacklocation object for each json object. Use fast enumeration here instead of a for loop. it's a touch slower but safer */
    [locationDictionaries enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        
        MSLocation *location = [self createLocationWithDictionary:item];
        [[self dataSource] addObject:location];
        
        NSNumber *locationId = [NSNumber numberWithInteger:[[item objectForKey:@"locationId"] integerValue]];
        if ([favs containsObject:locationId]){
            [mutableFavs addObject:location];
        }
        
    }];
    
    /** get the reference to locations view controller and set its datasource */
    NSArray *viewControllers = [[self tabBarController] viewControllers];
    MSLocationsViewController *locationsVC = [viewControllers objectAtIndex:1];
    [locationsVC setDataSource:[self dataSource]];
    
    UINavigationController *favsNav = [viewControllers objectAtIndex:2];
    
    /* cast to get a reference to the favorites view. Caution! topViewController is the vc currently atop the stack */
    MSFavoritesViewController *favsVC = (MSFavoritesViewController *)[favsNav topViewController];
    [favsVC setDataSource:mutableFavs];
}

- (MSLocation *)createLocationWithDictionary:(NSDictionary *)dict{
    
    /* map the JSON to a MapStackLocation object that we can then use all over our project */
    MSLocation *location = [[MSLocation alloc]init];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude  = [[dict objectForKey:@"latitude"] floatValue];
    coordinate.longitude = [[dict objectForKey:@"longitude"] floatValue];
    location.coordinate  = coordinate;
    
    [location setLocationId:[[dict objectForKey:@"locationId"] integerValue]];
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