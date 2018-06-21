//
//  RRGroupView.h
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRGroupView : UIView 

- (void)reloadWithTableViews:(NSArray<UITableView *> *)tableViews headerView:(UIView *)headerView prefrredIndex:(NSInteger)prefrredIndex;
- (void)scrollRequireGestureRecognizerToFail:(UIGestureRecognizer *)ges;

@property(nonatomic, assign) CGFloat stickValue;
@property(nonatomic, assign) BOOL restoreWhenIndexChange;

@property(nonatomic, assign, readonly) CGFloat headerHiddenProgress;
@property(nonatomic, copy) void(^headerHiddenProgressDidChange)(CGFloat progress);

@property(nonatomic, assign, readonly) NSInteger currentIndex;
@property(nonatomic, copy) void(^currentIndexDidChange)(NSInteger currentIndex);

@property(nonatomic, assign, readonly) CGFloat currentIndexValue;
@property(nonatomic, copy) void(^currentIndexValueDidChange)(CGFloat currentIndexValue);

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;

@end
