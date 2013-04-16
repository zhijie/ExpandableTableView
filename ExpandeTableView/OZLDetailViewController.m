//
//  OZLDetailViewController.m
//  ExpandeTableView
//
//  Created by Lee Zhijie on 4/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLDetailViewController.h"

@interface OZLDetailViewController () {
    UITableView *_tableview;
    NSMutableArray *_data;
}

@end

@implementation OZLDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    [titleLable setBackgroundColor:[UIColor grayColor]];
    [titleLable setText:_titleStr];
    [titleLable setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTapped)];
    [titleLable addGestureRecognizer:tap];
    [self.view addSubview:titleLable];
    
    _data = [[NSMutableArray alloc] init];
    [_data addObject:@"0"];
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 480 - 22 - 44)];
    [_tableview setDataSource:self];
    [_tableview setDelegate:self];
    [self.view addSubview:_tableview];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableview addSubview:refresh];
}

- (void)titleTapped
{
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)handleData:(UIRefreshControl*)refresh
{
    [_data addObject:[NSString stringWithFormat:@"%d",_data.count]];

    [refresh endRefreshing];
    [_tableview reloadData];
}

-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing..."];
        [self performSelector:@selector(handleData:) withObject:refresh afterDelay:1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel * cellview;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cellview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [cellview setBackgroundColor:[UIColor grayColor]];
        [cellview setTag:indexPath.row];
        [cell addSubview:cellview];
    }else {
        cellview = (UILabel *)[cell viewWithTag:indexPath.row];
    }
    // Configure the cell...
    [cellview setText:[_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
