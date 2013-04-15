//
//  OZLTableViewController+Transition.h
//  ExpandeTableView
//
//  Created by Lee Zhijie on 4/16/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Transitions)

// make a transition that looks like a modal view
//  is expanding from a subview
- (void)expandFromCelll:(UIView *)sourceView
       toViewController:(UIViewController *)viewController;

@end