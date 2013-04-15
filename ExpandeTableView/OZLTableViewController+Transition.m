//
//  OZLTableViewController+Transition.m
//  ExpandeTableView
//
//  Created by Lee Zhijie on 4/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OZLTableViewController+Transition.h"

@implementation UIViewController (Transitions)

// capture a screen-sized image of the receiver
- (UIImage *)imageViewFromScreen {
    // make a bitmap copy of the screen
    UIGraphicsBeginImageContextWithOptions(
                                           [UIScreen mainScreen].bounds.size, YES,
                                           [UIScreen mainScreen].scale);
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

// make a transform that causes the given subview to fill the screen
//  (when applied to an image of the screen)


- (void)expandFromCelll:(UIView *)sourceView
toViewController:(UIViewController *)viewController {
    
    // get an image of the screen
    UIImage *image = [self imageViewFromScreen];
    int seperator = sourceView.frame.origin.y + sourceView.frame.size.height;
    CGRect upperRect = CGRectMake(0, 0, 320, seperator);
    CGRect bottomRect = CGRectMake(0, seperator, 320, 480 - seperator);
    
    CGImageRef imageUp = CGImageCreateWithImageInRect([image CGImage], upperRect);
    UIImageView *upperView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageUp]];
    [upperView setFrame:upperRect];
    CGImageRef imageBottom = CGImageCreateWithImageInRect([image CGImage], bottomRect);
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageBottom]];
    [bottomView setFrame:bottomRect];
    
    //white backgound when animation
    UIView *whiteView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:whiteView];
    [self.view addSubview:upperView];
    [self.view addSubview:bottomView];
    
    // animate the transform
    [UIView animateWithDuration:0.4
                     animations:^(void) {
                         [upperView setFrame:CGRectMake(upperRect.origin.x, 44 - seperator, upperRect.size.width, upperRect.size.height)];
                         [bottomView setFrame:CGRectMake(bottomRect.origin.x, 480, bottomRect.size.width, bottomRect.size.height)];
                     } completion:^(BOOL finished) {
                         [self.navigationController pushViewController:viewController animated:NO];
                         [whiteView removeFromSuperview];
                         [upperView removeFromSuperview];
                         [bottomView removeFromSuperview];
                     }];
}

@end