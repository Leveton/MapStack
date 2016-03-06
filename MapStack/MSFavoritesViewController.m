//
//  MSFavoritesViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocationDetailViewController.h"
#import "MSFavoritesViewController.h"
#import "MSTableViewCell.h"
#import "MSSingleton.h"
#import "MSLocation.h"

#define kTableViewPadding    (20.0f)
@interface MSFavoritesViewController ()<UITableViewDataSource, UITableViewDelegate, MSTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MSFavoritesViewController

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
    [[self tableView] setContentInset:UIEdgeInsetsZero];
    /* this does double duty, ensuring that the table is intantiated */
    CGRect tableViewFrame = [[self tableView] frame];
    
    /*let's give the table a 20 point padding */
    tableViewFrame.origin.x     = kTableViewPadding;
    
    /*accomodate the navigatin bar and status bar */
    tableViewFrame.origin.y     = kTableViewPadding + 64.0f;
    
    tableViewFrame.size.width   = CGRectGetWidth([[self view] frame]) - (kTableViewPadding * 2);
    tableViewFrame.size.height  = CGRectGetHeight([[self view] frame]) - (kTableViewPadding * 2) - (48.0f + 64.0f);
    
    [[self tableView] setFrame:tableViewFrame];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        /*hide separator lines */
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [[self view] addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [[self tableView] reloadData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSLocation *location = [_dataSource objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"locationCell";
    MSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[MSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setDelegate:self];
    [cell setTag:indexPath.row];
    [cell setLocation:location];
    
    /*remove highlight when selected */
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* give enough room for our images */
    return 100.0f;
}

#pragma mark - MSTableViewCellDelegate

- (void)deleteButtonTappedFromCell:(MSTableViewCell *)cell{
    
    /* use good old favs and mutableFavs to get the id's of the favorited locations */
    NSArray *favs               = [[NSUserDefaults standardUserDefaults] objectForKey:@"favoritesArray"];
    NSNumber *locationId        = [favs objectAtIndex:cell.tag];
    NSMutableArray *mutableFavs = [[NSMutableArray alloc]initWithArray:favs];
    [mutableFavs removeObject:locationId];
    [[NSUserDefaults standardUserDefaults] setObject:mutableFavs forKey:@"favoritesArray"];
    
    /* get a mutable reference to our data source and remove the deleted location */
    MSLocation *location        = [_dataSource objectAtIndex:cell.tag];
    NSMutableArray *mutableLocs = [[NSMutableArray alloc]initWithArray:_dataSource];
    [mutableLocs removeObject:location];
    _dataSource                 = mutableLocs;
    
    /* class method to get the row that was tapped, our table has only 1 section so pass 0 */
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    
    /* triggers a .3 second animation for all UI related calls in between 'beginUpdates' and 'endUpdates' */
    [[self tableView] beginUpdates];
    [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableView] endUpdates];
    
    /**
     
     GCD method to grab the main thread and execute the block of code after .3 seconds (when endUpdates returns).
     Calling 'reloadData' outside this block would override 'beginUpdates'.
     
     */
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[self tableView] reloadData];
        
        /*post a notification to our settings view controller with the array. Using reverse domain name is conventional. */
        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.mapstack.favoritesUpdated" object:_dataSource userInfo:nil];
    });
    
}

- (void)detailsButtonTappedFromCell:(MSTableViewCell *)cell{
    
    /* Same code as 'didSelectRowAtIndexPath' from the last lasson */
    MSLocation *location = [_dataSource objectAtIndex:cell.tag];
    
    MSLocationDetailViewController *vc = [[MSLocationDetailViewController alloc]init];
    [vc setIsViewPresented:NO];
    [vc setLocation:location];
    [[self navigationController] pushViewController:vc animated:YES];
}

@end
