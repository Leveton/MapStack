//
//  MSSettingsViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSSettingsViewController.h"
#import "MSSingleton.h"

typedef enum NSInteger {
    kThemeColor,
    kTypeFilter,
    kDistanceFilter
}sectionHeaders;


@interface MSSettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nonnull) NSArray      *colorsArray;
@property (nonatomic, strong, nonnull) NSArray      *distancesArray;
@end

@implementation MSSettingsViewController

/* we override init here so our instance can listen for a notification that a favorite has been updated */
- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoritesUpdated:) name:@"com.mapstack.favoritesUpdated" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* make sure the global theme color has been set */
    if ([MSSingleton sharedSingleton].themeColor) {
        [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    }else{
        [[self view] setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    CGRect tableFrame      = [[self tableView] frame];
    tableFrame.origin.y    = 20.0f;
    tableFrame.size.width  = CGRectGetWidth([[self view] frame]);
    tableFrame.size.height = CGRectGetHeight([[self view] frame]) - 30.0f;
    [[self tableView] setFrame:tableFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* override dealloc to remove the listener. This prevents a nil object from receiving a message */
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"com.mapstack.favoritesUpdated"];
}

#pragma mark - getters

- (UITableView *)tableView{
    if (!_tableView){
        
        /*custom init method to get a grouped table as opposed to the default non-grouped table */
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [[self view] addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)colorsArray{
    if (!_colorsArray){
        _colorsArray = [[NSArray alloc] initWithObjects:@"blue color", @"green color", @"orange color", nil];
    }
    return _colorsArray;
}


- (NSDictionary *)sectionTitleDictionary {
    
    return @{
             @"0" : NSLocalizedString(@"App Theme Color", nil),
             @"1" : NSLocalizedString(@"Locations within range", nil),
             @"2" : NSLocalizedString(@"Rearrange favorite types", nil)};
}

- (NSDictionary *)locationRangeDictionary {
    
    return @{
             @"0" : NSLocalizedString(@"one mile", nil),
             @"1" : NSLocalizedString(@"two miles", nil),
             @"2" : NSLocalizedString(@"five miles", nil),
             @"3" : NSLocalizedString(@"ten miles", nil),
             @"4" : NSLocalizedString(@"twenty miles", nil),
             @"5" : NSLocalizedString(@"fifty miles", nil)};
}

- (UITableViewCell *)colorsCellForIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"colorsCell";
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [imageView setHidden:YES];
        [cell setAccessoryView:imageView];
    }
    
    [[cell textLabel] setText:[[self colorsArray] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)distanceCellForIndexPath:(NSIndexPath *)indexPath{
    
    /*convenience method on UIView for alloc and init */
    UITableViewCell *cell = [UITableViewCell new];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    [imageView setHidden:YES];
    [cell setAccessoryView:imageView];
    
    [[cell textLabel] setText:[[self locationRangeDictionary] objectForKey:[@(indexPath.row) stringValue]]];
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /* this flashes the cell upon tap which is good for UX */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == kThemeColor || indexPath.section == kDistanceFilter) {
        
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
        
        /*toggle the cell's right-hand view hidden */
        [[cell accessoryView] setHidden:![[cell accessoryView] isHidden]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kThemeColor){
        return [[self colorsArray] count];
    }
    if (section == kTypeFilter) {
        return [_typesArray count];
    }
    if (section == kDistanceFilter) {
        return [[[self locationRangeDictionary] allKeys] count];
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[[self sectionTitleDictionary] allKeys] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* with different sizes, labels, types, etc, let's use some helpers */
    
    if (indexPath.section == kThemeColor) {
        return  [self colorsCellForIndexPath:indexPath];
    }
    
    if (indexPath.section == kDistanceFilter) {
        return  [self distanceCellForIndexPath:indexPath];
    }
    
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[self view]frame]), 50.0f)];
    [view setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    
    UILabel *label  = [[UILabel alloc]initWithFrame:[view frame]];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    /* notice the NSNumber literal we passed to valueForKey, modern objective-C has array and dict literals as well */
    NSString *value = [[self sectionTitleDictionary] valueForKey:[@(section) stringValue]];
    
    [label setText:value];
    [view addSubview:label];
    return view;
}

#pragma mark - setters

- (void)setTypesArray:(NSArray *)typesArray{
    _typesArray = typesArray;
    [[self tableView] reloadData];
}

#pragma mark - selectors

- (void)favoritesUpdated:(NSNotification *)note{
    
    if ([note object]) {
        [self setTypesArray:[note object]];
    }
}

@end
