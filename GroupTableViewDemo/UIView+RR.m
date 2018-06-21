//
//  UIView+RR.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/21.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "UIView+RR.h"

@implementation UIView (RR)

- (UIView *)findSubviewOfClass:(Class)cls {
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:cls]) {
            return subView;
        }
    }
    return nil;
}

@end
