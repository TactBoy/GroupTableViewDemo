//
//  RRNavigationViewController.h
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRNavigationViewController : UINavigationController
//
@property (strong, nonatomic) UIView *shadowView;
@property (strong, nonatomic) UIView *barBackView;

- (void)setNeedsNavigationBackground:(CGFloat)alpha;

@end
