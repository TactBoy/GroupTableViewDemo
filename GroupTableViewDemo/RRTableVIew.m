//
//  RRTableVIew.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/14.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "RRTableVIew.h"

@interface RRTableVIew () <UIGestureRecognizerDelegate>

@end

@implementation RRTableVIew

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"%@ touchesBegan", self.name);
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesEnded:touches withEvent:event];
//    NSLog(@"%@ touchesEnded", self.name);
//
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesCancelled:touches withEvent:event];
//    NSLog(@"%@ touchesCancelled", self.name);
//
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    BOOL pointInside = [super pointInside:point withEvent:event];
//    NSLog(@"%@ pointInside = %@", self.name, pointInside ? @"Yes": @"NO");
//    return pointInside;
//}
//
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *view = [super hitTest:point withEvent:event];
//    NSLog(@"%@ hitTestView = %@", self.name, view);
//    return view;
//}

//- (UIResponder *)nextResponder {
//    UIResponder *next = [super nextResponder];
//    NSLog(@"%@ nextResponder = %@", self.name, next);
//    return next;
//}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ name: %@", self.class, self.name];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    BOOL should = [super gestureRecognizerShouldBegin:gestureRecognizer];
//    NSLog(@"******************");
//    NSLog(@"class: %@", gestureRecognizer.class);
//    NSLog(@"delaysTouchesBegan: %@", gestureRecognizer.delaysTouchesBegan ? @"yes": @"no");
//    NSLog(@"cancelsTouchesInView: %@", gestureRecognizer.cancelsTouchesInView ? @"yes": @"no");
//    NSLog(@"gestureRecognizerShouldBegin: %@", should ? @"yes": @"no");
//    NSLog(@"******************");
//    // 这个手势会导致初始化完成后headerview无法响应其他事件, 暂不清楚阻止该手势会带来什么bug
//    if ([gestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewDelayedTouchesBeganGestureRecognizer")]) {
//        should = NO;
//    }
//    return should;
//}


@end
