//
//  RRGroupHeaderView.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/21.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "RRGroupHeaderView.h"

@implementation RRGroupHeaderView

// iOS8 && iOS9 找不到方法会闪退
- (void)delaysContentTouches {
    NSLog(@"%s", __func__);
}

- (void)_touchDelayForScrollDetection {
    NSLog(@"%s", __func__);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    } else {
        NSMethodSignature *sig = [super methodSignatureForSelector:@selector(emptyFunc)];
        return sig;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self respondsToSelector:anInvocation.selector]) {
        [super forwardInvocation:anInvocation];
    } else {
        NSLog(@"notImplementMethond: %@", NSStringFromSelector(anInvocation.selector));
    }
}

- (void)emptyFunc {
    NSLog(@"%s", __func__);
}


@end
