//
//  RRGroupView.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "RRGroupView.h"

@interface RRGroupView () <UIScrollViewDelegate>

@end

@implementation RRGroupView {
    NSInteger _index;
    NSArray<UITableView *> *_tableViews;
    UIScrollView *_mainScrollView;
    UIView *_headerView;
    NSMutableArray<NSArray *> *_tableViewGestureeArr;
    BOOL _lockOffsetChange;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp {
    self.backgroundColor = [UIColor whiteColor];
    
}

- (void)_removeTableViewsObersrve {
    for (UITableView *tb in _tableViews) {
        [tb removeObserverBlocksForKeyPath:@"contentOffset"];
    }
}

#pragma mark -
#pragma mark -- -- -- -- -- - Public Methond - -- -- -- -- --
- (void)reloadWithTableViews:(NSArray<UITableView *> *)tableViews headerView:(UIView *)headerView prefrredIndex:(NSInteger)prefrredIndex {
    [self _removeTableViewsObersrve];
    _tableViews = tableViews;
    _headerView = headerView;
    prefrredIndex = MIN(tableViews.count - 1, prefrredIndex);
    prefrredIndex = MAX(0, prefrredIndex);
    _index = prefrredIndex;
    
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    
    _mainScrollView.contentSize = CGSizeMake(self.width * _tableViews.count, self.height);
    _mainScrollView.contentOffset = CGPointMake(self.width * _index, 0);
    _mainScrollView.frame = self.bounds;
    [self addSubview:_mainScrollView];

    _tableViewGestureeArr = [NSMutableArray new];

    NSInteger index = 0;
    for (UITableView *tb in _tableViews) {
        [tb addObserverBlockForKeyPath:@"contentOffset" block:^(UITableView *obj, id  _Nullable oldVal, id  _Nullable newVal) {
            CGPoint oldOffset = [(NSValue *)oldVal CGPointValue];
            CGPoint newOffset = [(NSValue *)newVal CGPointValue];
            [self _tableViewOffsetDidChange:obj oldOffset:oldOffset newOffset:newOffset];
        }];
        
        tb.frame = CGRectMake(index * self.width, 0, self.width, self.height);
        [_mainScrollView addSubview:tb];
        
        NSMutableArray *gesArr = tb.gestureRecognizers.mutableCopy;
        if (kSystemVersion < 10) {
            // 10 以下的系统不需要加这个手势
            for (UIGestureRecognizer *ges in gesArr.objectEnumerator.allObjects) {
                if ([ges isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")]) {
                    [gesArr removeObject:ges];
                }
            }
        }
        [_tableViewGestureeArr addObject:gesArr];
        
        UIEdgeInsets inset = tb.contentInset;
        inset.top += _headerView.height;
        tb.contentInset = inset;
        
        index++;
    }
    
    _headerView.frame = CGRectMake(0, 0, self.width, _headerView.height);
    [self addSubview:_headerView];
    
}

- (void)scrollRequireGestureRecognizerToFail:(UIGestureRecognizer *)ges {
    [_mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:ges];
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
    _currentIndex = currentIndex;
    [self scrollViewWillBeginDragging:_mainScrollView];
    [_mainScrollView setContentOffset:CGPointMake(currentIndex * self.width, 0) animated:animated];
}

#pragma mark -
#pragma mark -- -- -- -- -- - Private Methond - -- -- -- -- --

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = -_headerView.bottom;
    for (UITableView *tb in _tableViews) {
        CGPoint offset = tb.contentOffset;
        CGFloat insetTop = tb.contentInset.top;
        CGFloat finalOffsetY = offsetY - (insetTop - _headerView.height);
        if (_index < _tableViews.count) {
            UITableView *currrentTableView = _tableViews[_index];
            if (tb != currrentTableView) {
                if (_restoreWhenIndexChange) {
                    offset.y = finalOffsetY;
                } else {
                    if (offset.y < finalOffsetY) {
                        offset.y = finalOffsetY;
                    }
                }
                _lockOffsetChange = YES;
                tb.contentOffset = offset;
                _lockOffsetChange = NO;
            }
        }
    }
}

- (void)_tableViewOffsetDidChange:(UITableView *)tableView oldOffset:(CGPoint)oldOffset newOffset:(CGPoint)newOffset {
    if (_index < _tableViews.count && _lockOffsetChange == NO) {
        UITableView *tb = _tableViews[_index];
        if (tb == tableView) {
            CGFloat insetTop = tableView.contentInset.top;
            CGFloat transfrom = newOffset.y - oldOffset.y;
            CGFloat bottom = _headerView.bottom;
            bottom -= transfrom;
            bottom = MAX(bottom, _stickValue);
            bottom = MIN(bottom, _headerView.height);
            if (transfrom > 0) {
                // up
                if (newOffset.y + bottom < _headerView.height - insetTop) {
                    bottom = _headerView.height;
                }
            } else {
                // down
                if (newOffset.y + bottom >= _headerView.height - insetTop) {
                    bottom = _headerView.bottom;
                }
            }
            _headerView.bottom = bottom;
            _headerHiddenProgress = fabs((_headerView.bottom - _headerView.height) / (_headerView.height - _stickValue));
            _headerHiddenProgress = MAX(0, _headerHiddenProgress);
            _headerHiddenProgress = MIN(1, _headerHiddenProgress);
            if (self.headerHiddenProgressDidChange) {
                self.headerHiddenProgressDidChange(_headerHiddenProgress);
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _mainScrollView) {
        CGFloat index = (_mainScrollView.contentOffset.x / self.width);
        _currentIndexValue = index;
        if (self.currentIndexValueDidChange) {
            self.currentIndexValueDidChange(_currentIndexValue);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _buildIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self _buildIndex];
    }
}

- (void)_buildIndex {
    NSInteger index = (NSInteger)(_mainScrollView.contentOffset.x / self.width);
    index = MIN(_tableViews.count - 1, index);
    index = MAX(0, index);
    _index = index;
    _currentIndex = index;
    if (self.currentIndexDidChange) {
        self.currentIndexDidChange(_currentIndex);
    }
}

#pragma mark -
#pragma mark -- -- -- -- -- - Override - -- -- -- -- --
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_index < _tableViewGestureeArr.count) {
        NSArray<UIGestureRecognizer *> *gesArr = _tableViewGestureeArr[_index];
        if (CGRectContainsPoint(_headerView.frame, point)) {
            for (NSArray<UIGestureRecognizer *> *t_gesArr in _tableViewGestureeArr) {
                if (t_gesArr != gesArr) {
                    for (UIGestureRecognizer *ges in gesArr) {
                        [_headerView removeGestureRecognizer:ges];
                    }
                }
            }
            for (UIGestureRecognizer *ges in gesArr) {
                [_headerView addGestureRecognizer:ges];
            }
        } else {
            if (_index < _tableViews.count) {
                UITableView *tb = _tableViews[_index];
                for (NSArray<UIGestureRecognizer *> *t_gesArr in _tableViewGestureeArr) {
                    if (t_gesArr != gesArr) {
                        for (UIGestureRecognizer *ges in gesArr) {
                            [tb removeGestureRecognizer:ges];
                        }
                    }
                }
                for (UIGestureRecognizer *ges in gesArr) {
                    [tb addGestureRecognizer:ges];
                }
            }
        }
    }
//    NSLog(@"%@", _headerView.gestureRecognizers);
    return [super pointInside:point withEvent:event];
}





@end
