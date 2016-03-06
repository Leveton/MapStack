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
    tableFrame.size.height = CGRectGetHeight([[self view] frame]) - 20.0f;
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
        [[self view] addSubview:_tableView];
    }
    return _tableView;
}

- (NSDictionary *)sectionTitleDictionary {
    
    return @{
             @"0" : NSLocalizedString(@"App Theme Color", nil),
             @"1" : NSLocalizedString(@"Locations within range", nil),
             @"2" : NSLocalizedString(@"Rearrange favorite types", nil)};
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == kThemeColor){
        return [_colorsArray count];
    }
    if (section == kTypeFilter) {
        return [_typesArray count];
    }
    if (section == kDistanceFilter) {
        return [_distancesArray count];
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
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[self view]frame]), 50.0f)];
    [view setBackgroundColor:[MSSingleton sharedSingleton].themeColor];
    UILabel *label = [[UILabel alloc]initWithFrame:[view frame]];
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
}

@end
