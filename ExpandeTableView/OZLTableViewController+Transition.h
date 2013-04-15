//
//  OZLTableViewController+Transition.h
//  ExpandeTableView
//
//  Created by Lee Zhijie on 4/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewController (Transitions)

// make a transition that looks like a modal view
//  is expanding from a subview
- (void)expandView:(UIView *)sourceView
toModalViewController:(UIViewController *)modalViewController;

// make a transition that looks like the current modal view
//  is shrinking into a subview
- (void)dismissModalViewControllerToView:(UIView *)view;

@end