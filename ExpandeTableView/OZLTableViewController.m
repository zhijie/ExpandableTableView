//
//  OZLTableViewController.m
//  ExpandeTableView
//
//  Created by Lee Zhijie on 4/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLTableViewController.h"
#import "OZLDetailViewController.h"
#import "OZLTableViewController+Transition.h"

@interface OZLTableViewController () {
    NSArray *_data;
}

@end

@implementation OZLTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _data = @[@"A",@"B",@"C",@"D",@"E",@"F"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        cellview = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [cellview setBackgroundColor:[UIColor grayColor]];
        [cellview setTag:indexPath.row];
        [cell addSubview:cellview];
    }else {
        cellview = (UILabel *)[tableView viewWithTag:indexPath.row];
    }
    // Configure the cell...
    [cellview setText:[_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OZLDetailViewController *detailview = [[OZLDetailViewController alloc] init];
    detailview.titleStr = [_data objectAtIndex:indexPath.row];
    [self expandView:[tableView cellForRowAtIndexPath:indexPath] toModalViewController:detailview];
}

@end
