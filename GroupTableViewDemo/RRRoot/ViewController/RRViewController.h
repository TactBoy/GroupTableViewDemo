//
//  RRViewController.h
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRViewController : UIViewController

@end

@interface UIViewController (Alpha)
@property (nonatomic, assign) CGFloat barAlpha;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL hiddenBar;

- (void)setHiddenBar:(BOOL)hiddenBar animated:(BOOL)animated;

@end

