//
//  OZLExpandableTableView.m
//  ExpandeTableView
//
//  Created by lizhijie on 4/17/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import "OZLExpandableTableView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>


#define UPPERVIEW_TAG 1000
#define BOTTOMVIEW_TAG 1001
#define WHITEVIEW_TAG 1002

static const char *seperatorKey = "seperatorKey";

@implementation UIViewController (Expandable)
@dynamic seperator;


- (id)seperator {
    return objc_getAssociatedObject(self, seperatorKey);
}

- (void)setSeperator:(id)newSeperator {
    objc_setAssociatedObject(self, seperatorKey, newSeperator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

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


- (void)expandFromCell:(UIView *)sourceView
       toViewController:(UIViewController *)viewController {

    // get image of the screen
    UIImage *image = [self imageViewFromScreen];
    int sep = sourceView.frame.origin.y + sourceView.frame.size.height;
    [self setSeperator:[NSNumber numberWithInt:sep]];

    CGRect upperRect = CGRectMake(0, 22, 320, sep);
    CGRect bottomRect = CGRectMake(0, 22 + sep, 320, self.view.frame.size.height - sep);
    CGImageRef imageUp = CGImageCreateWithImageInRect([image CGImage], [self scaleRect:upperRect withScale:[UIScreen mainScreen].scale]);
    upperRect.origin.y = 0;
    UIImageView *upperView = [[UIImageView alloc] initWithFrame:upperRect];
    upperView.contentMode = UIViewContentModeScaleAspectFit;
    [upperView setImage:[UIImage imageWithCGImage:imageUp]];
    [upperView setTag:UPPERVIEW_TAG];

    CGImageRef imageBottom = CGImageCreateWithImageInRect([image CGImage], [self scaleRect:bottomRect withScale:[UIScreen mainScreen].scale ]);
    bottomRect.origin.y = sep;
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
                         [upperView setFrame:CGRectMake(upperRect.origin.x, 44 - sep, upperRect.size.width, upperRect.size.height)];
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

    int sep = [[self seperator] intValue];
    upperFrame.origin.y =0;
    bottomFrame.origin.y  = sep;

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
