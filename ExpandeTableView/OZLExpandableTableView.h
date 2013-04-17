//
//  OZLExpandableTableView.h
//  ExpandeTableView
//
//  Created by lizhijie on 4/17/13.
//  Copyright (c) 2013 Lee Zhijie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (Expandable)

@property(nonatomic,retain) id seperator;

- (void)expandFromCell:(UIView *)sourceView toViewController:(UIViewController *)viewController;
- (void)restoreFromExpandedCell;

@end
