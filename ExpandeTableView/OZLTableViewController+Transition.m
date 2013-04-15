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
- (UIImageView *)imageViewFromScreen {
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
    // make a view for the image
    UIImageView *imageView =[[UIImageView alloc] initWithImage:image];
    
    return(imageView);
}

// make a transform that causes the given subview to fill the screen
//  (when applied to an image of the screen)
- (CATransform3D)transformToFillScreenWithSubview:(UIView *)sourceView {
    // get the root view
    UIView *rootView = sourceView;
    while (rootView.superview) rootView = rootView.superview;
    // convert the source view's center and size into the coordinate
    //  system of the root view
    CGRect sourceRect = [sourceView convertRect:sourceView.bounds toView:rootView];
    CGPoint sourceCenter = CGPointMake(
                                       CGRectGetMidX(sourceRect), CGRectGetMidY(sourceRect));
    CGSize sourceSize = sourceRect.size;
    // get the size and position we're expanding it to
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    CGPoint targetCenter = CGPointMake(
                                       CGRectGetMidX(screenBounds),
                                       CGRectGetMidY(screenBounds));
    CGSize targetSize = screenBounds.size;
    // scale so that the view fills the screen
    CATransform3D t = CATransform3DIdentity;
    CGFloat sourceAspect = sourceSize.width / sourceSize.height;
    CGFloat targetAspect = targetSize.width / targetSize.height;
    CGFloat scale = 1.0;
    if (sourceAspect > targetAspect)
        scale = targetSize.width / sourceSize.width;
    else
        scale = targetSize.height / sourceSize.height;
    t = CATransform3DScale(t, scale, scale, 1.0);
    // compensate for the status bar in the screen image
    CGFloat statusBarAdjustment =
    (([UIApplication sharedApplication].statusBarFrame.size.height / 2.0)
     / scale);
    // transform to center the view
    t = CATransform3DTranslate(t,
                               (targetCenter.x - sourceCenter.x),
                               (targetCenter.y - sourceCenter.y) + statusBarAdjustment,
                               0.0);
    
    return(t);
}

- (void)expandView:(UIView *)sourceView
toModalViewController:(UIViewController *)modalViewController {
    
    // get an image of the screen
    UIImageView *imageView = [self imageViewFromScreen];
    
    // insert it into the modal view's hierarchy
    [self presentModalViewController:modalViewController animated:NO];
    UIView *rootView = modalViewController.view;
    while (rootView.superview) rootView = rootView.superview;
    [rootView addSubview:imageView];
    
    // make a transform that makes the source view fill the screen
    CATransform3D t = [self transformToFillScreenWithSubview:sourceView];
    
    // animate the transform
    [UIView animateWithDuration:0.4
                     animations:^(void) {
                         imageView.layer.transform = t;
                     } completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                     }];
}

- (void)dismissModalViewControllerToView:(UIView *)view {
    
    // take a snapshot of the current screen
    UIImageView *imageView = [self imageViewFromScreen];
    
    // insert it into the root view
    UIView *rootView = self.view;
    while (rootView.superview) rootView = rootView.superview;
    [rootView addSubview:imageView];
    
    // make the subview initially fill the screen
    imageView.layer.transform = [self transformToFillScreenWithSubview:view];
    // remove the modal view
    [self dismissModalViewControllerAnimated:NO];
    
    // animate the screen shrinking back to normal
    [UIView animateWithDuration:0.4 
                     animations:^(void) {
                         imageView.layer.transform = CATransform3DIdentity;
                     }
                     completion:^(BOOL finished) {
                         [imageView removeFromSuperview];
                     }];
}

@end