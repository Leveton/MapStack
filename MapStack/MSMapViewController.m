//
//  MSMapViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/23/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSProgressView.h"
#import "MSMapViewController.h"
#import "MSSettingsViewController.h"
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
@property (nonatomic, strong, nullable) MSProgressView               *progressView;
@end

@implementation MSMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* listen for a notification that the app's theme color changed */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appThemeColorChanged:) name:@"com.mapstack.themeColorWasChanged" object:nil];
    
    /* make sure the global theme color has been set */
    if ([MSSingleton sharedSingleton].themeColor) {
        [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    }else{
        [[self view] setBackgroundColor:[UIColor whiteColor]];
    }
    
    /* get the user's current location */
    [[self manager] startUpdatingLocation];
    
    /* 1 mile radius */
    MKCoordinateRegion adjustedRegion = [[self map] regionThatFits:MKCoordinateRegionMakeWithDistance([self centerPoint], 1609.34, 1609.34)];
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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"com.mapstack.themeColorWasChanged"];
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

- (MSProgressView *)progressView{
    if (!_progressView){
        _progressView = [[MSProgressView alloc]initWithFrame:CGRectZero];
        [_progressView setHidden:YES];
        [[self view] addSubview:_progressView];
    }
    return _progressView;
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

- (void)populateMap{
    
    [self shouldHideProgressView:NO];
    
    /* NSURLSessionDataTask returns data directly to the app in a block. This time, the block is exectuted when the response comes from the server */
    
    __block NSURLSessionDataTask *locationTask = [[self sessionLocations] dataTaskWithRequest:[self locationsRequest] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        
        if (!error){
            NSError *JSONSerializationError;
            
            /** convert raw bytes to JSON */
            id jsonResponse = [NSJSONSerialization
                               JSONObjectWithData:data
                               options:NSJSONReadingMutableContainers
                               error:&JSONSerializationError]; //dereference the object before passing it. look this up.
            
            if (JSONSerializationError){
                NSLog(@"populateMap JSON error: %@", JSONSerializationError.description);
                [locationTask cancel];
                [self getLocalData];
                return;
            }
            
            /* clear the current data sourcev */
            [[self dataSource] removeAllObjects];
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
        NSLog(@"getLocalData JSON error: %@", error.description);
        return;
    }
    
    [self layoutMapWithDictionary:jsonResponse];
}

- (void)layoutMapWithDictionary:(NSDictionary *)dictionary{
    
    /**
     grab the main UI thread since the current thread of execution hasn't returned from the NSURLSession. Remember, sessionLocations will hijack the current thread of execution because we use the default configuration rather than the background configuration.
     */
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
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
        
        MSSettingsViewController *settingsVC = [viewControllers objectAtIndex:3];
        [settingsVC setLocations:mutableFavs];
            
    });
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

- (void)shouldHideProgressView:(BOOL)hide{
    
    if (hide) {
        [[[self progressView] progressView] stopAnimating];
        [[self progressView] setHidden:YES];
        [[[self progressView] progressView] setHidden:YES];
    }else{
        [[self progressView] setFrame:[self mapFrame]];
        [[[self progressView] progressView] setHidden:NO];
        [[[self progressView] progressView] startAnimating];
        [[self progressView] setHidden:NO];
    }
}


#pragma mark - MKMapViewDelegate

/* fires when the pins get dropped */
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
    /** 
     this will fire almost immediately on a normal wifi connection (even a 3G connection). To see the spinner in action..
     Simulator: turn on Network link conditioner and set it to 'Edge'.
     Device: Go to Developer in Settings and find Network link conditioner and set it to 'edge'.
     */
    [self shouldHideProgressView:YES];
}

- (void)appThemeColorChanged:(NSNotification *)note{
    
    [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
}

@end
