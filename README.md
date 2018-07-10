# GroupTableViewDemo

 类似于新浪微博个人主页的UI效果在iOS中是很常见的, 实现的难度就在于既可以左右滑动, 也可以上下滑动. 

通常的做法是在一个横向滚动的`ScrollView`上添加几个竖向的`TableVIew`, 最后加一个`HeaderView`在`ScrollView`的`superView`上, 这么做的话会有一个问题就是`HeaderView`无法竖向滑动. 

有看到其它博客说给`HeaderView`加一个滑动手势, 来模拟`TableView`的滑动, 但是就缺少了`ScrollView`回弹的弹簧动画, 再后来有自己来实现弹簧动画的思路, 大佬果然棒棒哒, 什么困难都可以克服 😄

但是懒人懒办法, 有一个最简单有效的方法就是把`TableVIew`的`PanGesture`添加到最底层的`superView`上就可以了, 我们只需要对他做一些控制.

```
- (void)_buildIndex {
    NSInteger index = (NSInteger)(_mainScrollView.contentOffset.x / self.width);
    index = MIN(_tableViews.count - 1, index);
    index = MAX(0, index);
    [self removePanGestureForIndex:_index];
    _index = index;
    [self addPanGestureForIndex:_index];
    _currentIndex = index;
    if (self.currentIndexDidChange) {
        self.currentIndexDidChange(_currentIndex);
    }
}

- (void)addPanGestureForIndex:(NSInteger)index {
    if (index < _tableViews.count && index >= 0) {
        UITableView *tb = _tableViews[index];
        [self addGestureRecognizer:tb.panGestureRecognizer];
    }
}

- (void)removePanGestureForIndex:(NSInteger)index {
    if (index < _tableViews.count && index >= 0) {
        UITableView *tb = _tableViews[index];
        [self removeGestureRecognizer:tb.panGestureRecognizer];
    }
}
```

最终实现效果如下:
![](https://github.com/TactBoy/GroupTableViewDemo/blob/master/Demo.gif)
