//
//  MSSettingsViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocationsViewController.h"
#import "MSSettingsViewController.h"
#import "MSRange.h"

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
@end

@implementation MSSettingsViewController

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
        _colorsArray = [[NSArray alloc] initWithObjects:NSLocalizedString(@"blue color",nil), NSLocalizedString(@"green color", nil), NSLocalizedString(@"red color", nil), nil];
    }
    return _colorsArray;
}

- (NSArray *)typesArray{
    if (!_typesArray){
        _typesArray = [[NSArray alloc] initWithObjects:@"Hospital", @"School", @"StartUp", @"Random", @"Restaurant", nil];
    }
    return _typesArray;
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
             @"1" : NSLocalizedString(@"Rearrange favorite types", nil),
             @"2" : NSLocalizedString(@"Set Locations range", nil)};
}

- (NSDictionary *)locationRangeDictionary {
    
    return @{
             @"0" : NSLocalizedString(@"between 0 and 300 meters", nil),
             @"1" : NSLocalizedString(@"between 300 and 750 meters", nil),
             @"2" : NSLocalizedString(@"between 750 and 3000 meters", nil),
             @"3" : NSLocalizedString(@"between 3000 and 10000 meters", nil),
             @"4" : NSLocalizedString(@"no range", nil)};
}

- (UITableViewCell *)colorsCellForIndexPath:(NSIndexPath *)indexPath{
    
    /* Even though there aren't many cells, we can hook into whether a cell is just allocated and set some things there (e.g. our accessory label) */
    
    static NSString *CellIdentifier = @"colorsCell";
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [imageView setHidden:indexPath.row > 0];
        [cell setAccessoryView:imageView];
    }
    
    [[cell textLabel] setText:[[self colorsArray] objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UITableViewCell *)distanceCellForIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"distanceCell";
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        [imageView setHidden:YES];
        [cell setAccessoryView:imageView];
    }
    
    [[cell textLabel] setText:[[self locationRangeDictionary] objectForKey:[@(indexPath.row) stringValue]]];
    
    return cell;
}


- (UITableViewCell *)typeCellForIndexPath:(NSIndexPath *)indexPath{
    
    /*convenience method on UIView for alloc and init */
    UITableViewCell *cell = [UITableViewCell new];
    
    /*prevent highlight upon tap */
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    /* allow cell to be reoredered */
    [cell setShowsReorderControl:YES];
    
    [[cell textLabel] setText:[[self typesArray] objectAtIndex:indexPath.row]];
    
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
        
        /* hide all checks */
        [self hideAllChecksForIndexPath:indexPath];
        [[cell accessoryView] setHidden:![[cell accessoryView] isHidden]];
        
        MSLocationsViewController *vc = [[[self tabBarController] viewControllers] objectAtIndex:1];
        [vc setRange:[self getRangeFromIndexPath:indexPath]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == kThemeColor){
        return [[self colorsArray] count];
    }
    if (section == kTypeFilter) {
        return [[self typesArray] count];
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
    
    //[MSSingleton sharedSingleton].areFavoriteTypesOrdered = YES;
    
    /*update our data source to refect the change */
    NSMutableArray *mutableTypes = [[NSMutableArray alloc]initWithArray:[self typesArray]];
    NSString *sourceString       = [[self typesArray] objectAtIndex:sourceIndexPath.row];
    [mutableTypes removeObjectAtIndex:sourceIndexPath.row];
    [mutableTypes insertObject:sourceString atIndex:destinationIndexPath.row];
    [self setTypesArray:mutableTypes];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.mapstack.favoritesOrderWasRearranged" object:[self typesArray] userInfo:nil];

}

#pragma mark - setters

- (void)setLocations:(NSArray *)locations{
    _locations = locations;
    
    /* convenience init for array that will store the type strings */
    __block NSMutableArray *typeStringsArray = [NSMutableArray array];
    [_locations enumerateObjectsUsingBlock:^(MSLocation *item, NSUInteger idx, BOOL *stop) {
        [typeStringsArray addObject:[item type]];
    }];
}

#pragma mark - selectors

//TODO: Refactor case 4 for a cleaner implementation. notice that this 'todo' shows up if you tap the file helper at the top
- (MSRange *)getRangeFromIndexPath:(NSIndexPath *)indexPath{
    
    MSRange *range = [[MSRange alloc]init];
    /* safety check */
    
    if (indexPath.section == kDistanceFilter){
        switch (indexPath.row) {
            case 0:
                [range setStartPoint:0.0f];
                [range setEndPoint:300.0f];
                break;
            case 1:
                [range setStartPoint:300.0f];
                [range setEndPoint:750.0f];
                break;
            case 2:
                [range setStartPoint:750.0f];
                [range setEndPoint:3000.0f];
                break;
            case 3:
                [range setStartPoint:3000.0f];
                [range setEndPoint:10000.0f];
                break;
                
            /*larger than the size of the globe. */
            case 4:
                [range setStartPoint:0.0f];
                [range setEndPoint:1000000000000.0f];
                break;
                
            default:
                [range setStartPoint:0.0f];
                [range setEndPoint:1000000.0f];
                break;
        }
    }
    return range;
}

- (void)didTapEditTypes:(id)sender{
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
}

@end
