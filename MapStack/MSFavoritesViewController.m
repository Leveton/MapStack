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
@interface MSFavoritesViewController ()<UITableViewDataSource, UITableViewDelegate>
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSLocation *location = [_dataSource objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"locationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[location title]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"distance: %f", location.distance]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSLocation *location = [_dataSource objectAtIndex:indexPath.row];
    
    MSLocationDetailViewController *vc = [[MSLocationDetailViewController alloc]init];
    [vc setIsViewPresented:NO];
    [vc setLocation:location];
    [[self navigationController] pushViewController:vc animated:YES];
}


@end
