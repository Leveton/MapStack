//
//  MSLocationsViewController.m
//  MapStack
//
//  Created by Mike Leveton on 2/25/16.
//  Copyright © 2016 Mike Leveton. All rights reserved.
//

#import "MSLocation.h"
#import "MSSingleton.h"
#import "MSLocationsViewController.h"
#import "MSLocationDetailViewController.h"

#define kTableViewPadding    (20.0f)
@interface MSLocationsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation MSLocationsViewController

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
    
    /* this does double duty, ensuring that the table is intantiated */
    CGRect tableViewFrame = [[self tableView] frame];
    
    /*let's give the table a 20 point padding */
    tableViewFrame.origin.x     = kTableViewPadding;
    tableViewFrame.origin.y     = kTableViewPadding;
    tableViewFrame.size.width   = CGRectGetWidth([[self view] frame]) - (kTableViewPadding * 2);
    tableViewFrame.size.height  = CGRectGetHeight([[self view] frame]) - (kTableViewPadding * 2) - 48.0f;
    
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
    
    /* sort by distance from highest to lowest */
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                                     ascending:NO];
    _dataSource = [_dataSource sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    [[self tableView] reloadData];
}

/* cmd+click into this pragma to see the required methods */
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataSource count];
}

/* uncomment this to show a thousand reused rows */

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"locationCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        NSLog(@"new cell");
//    }else{
//        NSLog(@"old cell");
//    }
//    [[cell textLabel] setText:[NSString stringWithFormat:@"row %ld", (long)indexPath.row]];
//    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"bottom %ld", (long)indexPath.row]];
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MSLocation *location = [_dataSource objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"locationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[location title]];

    /* format the float as an int so that users don't see six decimal places */
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"distance: %ld meters", (long)location.distance]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MSLocation *location = [_dataSource objectAtIndex:indexPath.row];
    
    MSLocationDetailViewController *vc = [[MSLocationDetailViewController alloc]init];
    [vc setIsViewPresented:YES];
    [vc setLocation:location];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
