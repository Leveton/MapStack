//
//  MSSettingsViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSSettingsViewController.h"

typedef enum NSInteger {
    kThemeColor,
    kTypeFilter,
    kDistanceFilter
}sectionHeaders;


@interface MSSettingsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, nullable) UITableView *tableView;
@property (nonatomic, strong, nonnull) NSArray      *colorsArray;
@property (nonatomic, strong, nonnull) NSArray      *distancesArray;
@property (nonatomic, strong, nonnull) NSArray      *typesArray;
@property (nonatomic, strong, nonnull) NSDictionary *favoritesOrderDictionary;
@end

@implementation MSSettingsViewController

/* we override init here so our instance can listen for a notification that a favorite has been updated */
- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteAdded:) name:@"com.mapstack.locationFavorited" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteRemoved:) name:@"com.mapstack.locationUnfavorited" object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:@"com.mapstack.locationUnfavorited"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"com.mapstack.locationFavorited"];
}

#pragma mark - getters

- (UITableView *)tableView{
    if (!_tableView){
        
        /*custom init method to get a grouped table as opposed to the default non-grouped table */
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        /* set to yes to allow themes and favorites to be tapped even though we set their 'allowEditing' to NO in the delegate */
        [_tableView setAllowsSelectionDuringEditing:YES];
        
        [[self view] addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)colorsArray{
    if (!_colorsArray){
        _colorsArray = [[NSArray alloc] initWithObjects:@"blue color", @"green color", @"red color", nil];
    }
    return _colorsArray;
}

- (NSDictionary *)favoritesOrderDictionary{
    if (!_favoritesOrderDictionary){
        _favoritesOrderDictionary = [self initialOrderDictionary];
    }
    return _favoritesOrderDictionary;
}

- (UIColor *)blueColor{
    return [UIColor colorWithRed:74.0/255.0 green:144.0/255.0 blue:226.0/255.0 alpha:1.0];
}

- (UIColor *)greenColor{
    return [UIColor colorWithRed:74.0/255.0 green:226.0/255.0 blue:156.0/255.0 alpha:1.0];
}

- (UIColor *)redColor{
    return [UIColor colorWithRed:226.0/255.0 green:80.0/255.0 blue:74.0/255.0 alpha:1.0];
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

- (NSDictionary *)initialOrderDictionary {
    
    return @{
             @"Random"     : @(kFavoriteTypeRandom),
             @"Restaurant" : @(kFavoriteTypeRestaurant),
             @"School"     : @(kFavoriteTypeSchool),
             @"StartUp"    : @(kFavoriteTypeStartUp),
             @"Hospital"   : @(kFavoriteTypeHospital),};
}

- (UITableViewCell *)colorsCellForIndexPath:(NSIndexPath *)indexPath{
    
    /* we can use a reusable cell or a simple cell like in distanceCellForIndex */
    
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

- (UITableViewCell *)typeCellForIndexPath:(NSIndexPath *)indexPath{
    
    /*convenience method on UIView for alloc and init */
    UITableViewCell *cell = [UITableViewCell new];
    
    /* allow cell to be reoredered */
    [cell setShowsReorderControl:YES];
    
    [[cell textLabel] setText:[_typesArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDataSource

/* setting UITableViewCellEditingStyleNone prevents cells from displaying a red button for deletion */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)hideAllChecksForIndexPath:(NSIndexPath *)indexPath{
    
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:indexPath.section]; i++) {
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
        [[cell accessoryView] setHidden:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* this flashes the cell upon tap which is good for UX */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == kThemeColor) {
        
        /* hide all checks */
        [self hideAllChecksForIndexPath:indexPath];
        
        /*toggle the cell's right-hand view hidden */
        [[cell accessoryView] setHidden:![[cell accessoryView] isHidden]];
        
        switch (indexPath.row) {
            case 0:
                [MSSingleton sharedSingleton].themeColor = [self blueColor];
                break;
            case 1:
                [MSSingleton sharedSingleton].themeColor = [self greenColor];
                break;
            case 2:
                [MSSingleton sharedSingleton].themeColor = [self redColor];
                break;
                
            default:
                [MSSingleton sharedSingleton].themeColor = [self blueColor];
                break;
        }
        
        [[self view] setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
        /* a perfect example of when to broadcast a notification */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.mapstack.themeColorWasChanged" object:nil userInfo:nil];
        
        /* so that the header colors are reset */
        [[self tableView] reloadData];
    }
    
    if (indexPath.section == kDistanceFilter) {
        
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
    
    if (indexPath.section == kTypeFilter) {
        return  [self typeCellForIndexPath:indexPath];
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
    
    if (section == kTypeFilter){
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect editFrame     = [view frame];
        editFrame.origin.x   = CGRectGetWidth([[self view] frame]) - 40.0f;
        editFrame.size.width = 40.0f;
        [editButton setFrame:editFrame];
        [editButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [editButton setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
        [editButton.titleLabel setFont:[UIFont fontWithName:@"Chalkduster" size:10]];
        [editButton setTitleColor:[MSSingleton sharedSingleton].themeColor forState:UIControlStateNormal];
        
        /* the color for when the finger is actually on the button */
        [editButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        
        [editButton addTarget:self action:@selector(didTapEditTypes:) forControlEvents:UIControlEventTouchUpInside];
        [[editButton layer] setZPosition:2.0];
        [editButton setBackgroundColor:[UIColor darkGrayColor]];
        [view addSubview:editButton];
    }
    
    return view;
}

/* we only want cells in our 'type' group to be movable so we must implement this delegate methdod */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == kTypeFilter) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kTypeFilter) {
        return YES;
    }
    
    return NO;
}

/* gets called after the rows have been reordered */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    [MSSingleton sharedSingleton].areFavoriteTypesOrdered = YES;
    
    /*update our data source to refect the change */
    NSMutableArray *mutableTypes = [[NSMutableArray alloc]initWithArray:_typesArray];
    NSString *sourceString       = [_typesArray objectAtIndex:sourceIndexPath.row];
    [mutableTypes removeObjectAtIndex:sourceIndexPath.row];
    [mutableTypes insertObject:sourceString atIndex:destinationIndexPath.row];
    _typesArray                  = mutableTypes;
}

#pragma mark - setters

/* setters don't have to be public although they don't offer any real advantage when private other than code clarity */
- (void)setTypesArray:(NSArray *)typesArray{
    _typesArray = typesArray;
    
    /* data source for the types group is ready */
    [[self tableView] reloadData];
}

- (void)setLocations:(NSArray *)locations{
    _locations = locations;
    
    /* convenience init for array that will store the type strings */
    __block NSMutableArray *typeStringsArray = [NSMutableArray array];
    [_locations enumerateObjectsUsingBlock:^(MSLocation *item, NSUInteger idx, BOOL *stop) {
        [typeStringsArray addObject:[item type]];
    }];
    
    /*filter out duplicate strings with a set */
    NSMutableSet *typesSet = [NSMutableSet setWithArray:typeStringsArray];
    [self setTypesArray:[typesSet allObjects]];
    
}

#pragma mark - selectors

- (void)didTapEditTypes:(id)sender{
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
}

- (void)favoriteAdded:(NSNotification *)note{
    
    if ([note object]) {
        NSMutableArray *locations = [[NSMutableArray alloc]initWithArray:_typesArray];
        MSLocation *location = [note object];
        [locations addObject:[location type]];
        
        /*filter out duplicate strings with a set */
        NSMutableSet *typesSet = [NSMutableSet setWithArray:locations];
        [self setTypesArray:[typesSet allObjects]];
    }
}

- (void)favoriteRemoved:(NSNotification *)note{
    
    if ([note object]) {
        
        NSMutableArray *locations = [[NSMutableArray alloc]initWithArray:_typesArray];
        MSLocation *location = [note object];
        
        /* check for existence or you'll crash */
        if ([locations containsObject:[location type]]) {
            [locations removeObject:[location type]];
            
            /*filter out duplicate strings with a set */
            NSMutableSet *typesSet = [NSMutableSet setWithArray:locations];
            [self setTypesArray:[typesSet allObjects]];
        }
    }
}


@end
