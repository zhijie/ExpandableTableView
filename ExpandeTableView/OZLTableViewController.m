//
//  OZLTableViewController.m
//  ExpandeTableView
//
//  Created by Lee Zhijie on 4/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLTableViewController.h"
#import "OZLDetailViewController.h"
#import <QuartzCore/QuartzCore.h>


#define UPPERVIEW_TAG 1000
#define BOTTOMVIEW_TAG 1001
#define WHITEVIEW_TAG 1002

@interface OZLTableViewController () {
    NSArray *_data;
    int _seperator;
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

-(void) viewWillAppear:(BOOL)animated
{
    [self restoreFromExpandedCell];
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
//        [cellview setBackgroundColor:[UIColor grayColor]];
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
    OZLDetailViewController *detailview = [[OZLDetailViewController alloc] init];
    detailview.titleStr = [_data objectAtIndex:indexPath.row];
    [self expandFromCelll:[tableView cellForRowAtIndexPath:indexPath] toViewController:detailview];
    
}


#pragma mark -animation util

// capture a screen-sized image of the receiver
- (UIImage *)imageViewFromScreen {
    // make a bitmap copy of the screen
    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES,[UIScreen mainScreen].scale);
    // get the root layer
    CALayer *layer = self.view.layer;
    while(layer.superlayer) {
        layer = layer.superlayer;
    }
    // render it into the bitmap
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    // get the image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // close the context
    UIGraphicsEndImageContext();

    return(image);
}

- (CGRect) scaleRect:(CGRect)rect withScale:(float) scale
{
    return CGRectMake(rect.origin.x * scale, rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
}
- (void)expandFromCelll:(UIView *)sourceView
       toViewController:(UIViewController *)viewController {

    // get image of the screen
    UIImage *image = [self imageViewFromScreen];
    _seperator = sourceView.frame.origin.y + sourceView.frame.size.height;
    CGRect upperRect = CGRectMake(0, 22, 320, _seperator);
    CGRect bottomRect = CGRectMake(0, 22 + _seperator, 320, self.view.frame.size.height - _seperator);
    CGImageRef imageUp = CGImageCreateWithImageInRect([image CGImage], [self scaleRect:upperRect withScale:[UIScreen mainScreen].scale]);
    upperRect.origin.y = 0;
    UIImageView *upperView = [[UIImageView alloc] initWithFrame:upperRect];
    upperView.contentMode = UIViewContentModeScaleAspectFit;
    [upperView setImage:[UIImage imageWithCGImage:imageUp]];
    [upperView setTag:UPPERVIEW_TAG];

    CGImageRef imageBottom = CGImageCreateWithImageInRect([image CGImage], [self scaleRect:bottomRect withScale:[UIScreen mainScreen].scale ]);
    bottomRect.origin.y = _seperator;
    UIImageView *bottomView = [[UIImageView alloc] initWithFrame:bottomRect];
    bottomView.contentMode = UIViewContentModeScaleAspectFit;
    [bottomView setImage:[UIImage imageWithCGImage:imageBottom]];
    [bottomView setTag:BOTTOMVIEW_TAG];

    //white backgound when animation
    UIView *whiteView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [whiteView setTag:WHITEVIEW_TAG];
    [self.view addSubview:whiteView];
    [self.view addSubview:upperView];
    [self.view addSubview:bottomView];

    // animate the transform
    [UIView animateWithDuration:0.5
                     animations:^(void) {
                         [upperView setFrame:CGRectMake(upperRect.origin.x, 44 - _seperator, upperRect.size.width, upperRect.size.height)];
                         [bottomView setFrame:CGRectMake(bottomRect.origin.x, 480, bottomRect.size.width, bottomRect.size.height)];
                     } completion:^(BOOL finished) {
                         [self.navigationController pushViewController:viewController animated:NO];
                     }];
}

- (void)restoreFromExpandedCell
{
    UIView *upperView = [self.view viewWithTag:UPPERVIEW_TAG];
    UIView *bottomView = [self.view viewWithTag:BOTTOMVIEW_TAG];
    UIView *whiteView = [self.view viewWithTag:WHITEVIEW_TAG];
    if (!whiteView) {
        return;
    }
    CGRect upperFrame = upperView.frame;
    CGRect bottomFrame = bottomView.frame;

    upperFrame.origin.y =0;
    bottomFrame.origin.y  = _seperator;

    // animate the transform
    [UIView animateWithDuration:0.5
                     animations:^(void) {
                         [upperView setFrame:upperFrame];
                         [bottomView setFrame:bottomFrame];
                     } completion:^(BOOL finished) {
                         [whiteView removeFromSuperview];
                         [upperView removeFromSuperview];
                         [bottomView removeFromSuperview];
                     }];
    
}

@end
