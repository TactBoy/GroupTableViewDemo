//
//  RRNavigationViewController.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "RRNavigationViewController.h"
#import "RRViewController.h"
#import "Aspects.h"


@interface RRNavigationViewController ()<UINavigationBarDelegate, UINavigationControllerDelegate>
@property(weak, nonatomic) id<AspectToken> token;
@property (strong, nonatomic) UIView *searbarSepView; // iOS 11 searchBar的分割线


@end

@implementation RRNavigationViewController

- (void)dealloc
{
    [_token remove];
    [self.shadowView removeObserverBlocks];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    NSError *error;
    NSString *methondName = @"_updateInteractiveTransition:";
    SEL originalSelector = NSSelectorFromString(methondName);
    _token = [self aspect_hookSelector:originalSelector withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> sender, CGFloat percentComplete){
        @strongify(self);
        [self _swizzled__updateInteractiveTransition:percentComplete];
    } error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    if (!self.delegate) {
        self.delegate = self;
    }
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.searbarSepView) {
        UIView *view = [self.view findSubviewOfClass:NSClassFromString(@"_UINavigationControllerPaletteClippingView")];
        view = [view findSubviewOfClass:NSClassFromString(@"_UINavigationControllerManagedSearchPalette")];
        view = [view findSubviewOfClass:NSClassFromString(@"_UIBarBackground")];
        view = [view findSubviewOfClass:NSClassFromString(@"UIImageView")];
        self.searbarSepView = view;
    }
}

/* NavigationBar结构 iOS11 && iOS10
{
    "_UIBarBackground" =     {
        UIImageView = "";              // shadowView
        UIVisualEffectView =  UIView   { // barBackView
            "_UIVisualEffectBackdropView" = "_UIVisualEffectSubview -> UIView";
            "_UIVisualEffectSubview" = "_UIVisualEffectSubview -> UIView";
        };
    };
    "_UINavigationBarContentView" =     {
        UILabel = "";
    };
    "_UINavigationBarLargeTitleView" =     {
        UILabel = "";
    };
    "_UINavigationBarModernPromptView" =     {
        UILabel = "";
    };
 }
*/

/* NavigationBar结构 iOS8 && iOS9
UINavigationItemView =     {
    UILabel = "";
};
"_UINavigationBarBackIndicatorView" = ""
"_UINavigationBarBackground" =     {
    UIImageView = "";                     // shadowView
    "_UIBackdropView" = UIView     {      // barBackView
        UIView = "";
        "_UIBackdropEffectView" = "UIView";
    };
};
*/

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (!self.shadowView || !self.shadowView.superview) {
        [self.shadowView removeObserverBlocks];
        if (version >= 10) {
            UIView *view = [[self.navigationBar findSubviewOfClass:NSClassFromString(@"_UIBarBackground")] findSubviewOfClass:NSClassFromString(@"UIImageView")];
            self.shadowView = view;
        } else {
            // iOS 8 or IOS 9
            UIView *view = [[self.navigationBar findSubviewOfClass:NSClassFromString(@"_UINavigationBarBackground")] findSubviewOfClass:NSClassFromString(@"UIImageView")];
            self.shadowView = view;
        }
        if (self.shadowView) {
            // shadowView 的alpha系统会自己更改, 根据需求自己来写判断逻辑
            [self.shadowView removeObserverBlocks];
            @weakify(self);
            [self.shadowView addObserverBlockForKeyPath:@"alpha" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
                @strongify(self);
                CGFloat alpha = [self.topViewController barAlpha];
                if (alpha != self.shadowView.alpha) {
                    self.shadowView.alpha = alpha;
                }
            }];
        }
    }
    if (!self.barBackView || !self.barBackView.superview) {
        [self.barBackView removeObserverBlocks];
        if (version >= 10) {
            UIView *view = [[self.navigationBar findSubviewOfClass:NSClassFromString(@"_UIBarBackground")] findSubviewOfClass:NSClassFromString(@"UIVisualEffectView")];
            self.barBackView = view;
        } else {
            UIView *view = [[self.navigationBar findSubviewOfClass:NSClassFromString(@"_UINavigationBarBackground")] findSubviewOfClass:NSClassFromString(@"_UIBackdropView")];
            self.barBackView = view;
        }
    }
    
//    NSMutableDictionary *info = [NSMutableDictionary new];
//    for (UIView *view in self.navigationBar.subviews) {
//        NSLog(@"--%@ %@", view.class, view.superclass);
//        [info setObject:[NSMutableDictionary new] forKey:NSStringFromClass(view.class)];
//
//        for (UIView *subView1 in view.subviews) {
//            NSMutableDictionary *dic = info[NSStringFromClass(view.class)];
//            NSLog(@"----%@ %@", subView1.class, subView1.superclass);
//            [dic setObject:subView1.subviews.count ? [NSMutableDictionary new] : @"" forKey:NSStringFromClass(subView1.class)];
//
//            for (UIView *subView2 in subView1.subviews) {
//                NSMutableDictionary *dic2 = dic[NSStringFromClass(subView1.class)];
//                NSLog(@"------%@ %@ %@", subView2.class, subView2.superclass, subView2.superclass.superclass);
//                [dic2 setObject:subView2.subviews.count ? [NSMutableDictionary new] : @"" forKey:NSStringFromClass(subView2.class)];
//            }
//        }
//    }
//
//    NSLog(@"%@", info);
//    NSLog(@"--------------------------------");
}


- (void)exchange {
    NSString *methondName = @"_updateInteractiveTransition:";
    SEL originalSelector = NSSelectorFromString(methondName);
    SEL swizzledSelector = NSSelectorFromString([NSString stringWithFormat:@"_swizzled_%@", methondName]);
    Method originalMethond = class_getInstanceMethod(self.classForCoder, originalSelector);
    Method swizzledMethond = class_getInstanceMethod(self.classForCoder, swizzledSelector);
    method_exchangeImplementations(originalMethond, swizzledMethond);
}

- (void)_swizzled__updateInteractiveTransition:(CGFloat)percentComplete {
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id <UIViewControllerTransitionCoordinator> coord = topVC.transitionCoordinator;
        UIViewController *fromeVC = [coord viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [coord viewControllerForKey:UITransitionContextToViewControllerKey];
        CGFloat fromAlpha = fromeVC.barAlpha;
        CGFloat toAlpha = toVC.barAlpha;
        CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
        [self setNeedsNavigationBackground:nowAlpha];
        
        UIColor *fromColor = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].tintColor;
        UIColor *toColor = [coord viewControllerForKey:UITransitionContextToViewControllerKey].tintColor;
        UIColor *nowColor = [self.class averageColorWithFrome:fromColor toColor:toColor percent:percentComplete];
        [self.navigationBar setTintColor:nowColor];
        
        {
            UIColor *fromColor = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].barTintColor;
            UIColor *toColor = [coord viewControllerForKey:UITransitionContextToViewControllerKey].barTintColor;
            UIColor *nowColor;
            if (!fromColor) {
                nowColor = [toColor colorWithAlphaComponent:percentComplete];
            } else if (!toColor) {
                nowColor = [fromColor colorWithAlphaComponent:percentComplete];
            } else {
                nowColor = [self.class averageColorWithFrome:fromColor toColor:toColor percent:percentComplete];
            }
            [self.navigationBar setBarTintColor:nowColor];
        }
    }
}


#pragma mark -
#pragma mark -- -- -- -- -- - NavDelegate - -- -- -- -- --
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id <UIViewControllerTransitionCoordinator> coord = topVC.transitionCoordinator;
        if (coord) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
                @weakify(self);
                [coord notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    @strongify(self);
                    if ([context isCancelled]) {
                        CGFloat animationTime = [context transitionDuration] * [context percentComplete];
                        [UIView animateWithDuration:animationTime animations:^{
                            CGFloat fromAlpha = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].barAlpha;
                            [self setNeedsNavigationBackground:fromAlpha];
                            UIColor *fromColor = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].tintColor;
                            [self.navigationBar setTintColor:fromColor];
                            UIColor *fromBarColor = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].barTintColor;
                            [self.navigationBar setBarTintColor:fromBarColor];
                        }];
                    } else {
                        CGFloat animationTime = [context transitionDuration] * (1 - [context percentComplete]);
                        [UIView animateWithDuration:animationTime animations:^{
                            CGFloat toAlpha = [coord viewControllerForKey:UITransitionContextToViewControllerKey].barAlpha;
                            [self setNeedsNavigationBackground:toAlpha];
                            UIColor *toColor = [coord viewControllerForKey:UITransitionContextToViewControllerKey].tintColor;
                            [self.navigationBar setTintColor:toColor];
                            UIColor *toBarColor = [coord viewControllerForKey:UITransitionContextToViewControllerKey].barTintColor;
                            [self.navigationBar setBarTintColor:toBarColor];
                        }];
                    }
                }];
            } else {
                @weakify(self);
                [coord notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    @strongify(self);
                    if ([context isCancelled]) {
                        CGFloat animationTime = [context transitionDuration] * [context percentComplete];
                        [UIView animateWithDuration:animationTime animations:^{
                            CGFloat fromAlpha = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].barAlpha;
                            [self setNeedsNavigationBackground:fromAlpha];
                            UIColor *fromColor = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].tintColor;
                            [self.navigationBar setTintColor:fromColor];
                            UIColor *fromBarColor = [coord viewControllerForKey:UITransitionContextFromViewControllerKey].barTintColor;
                            [self.navigationBar setBarTintColor:fromBarColor];
                        }];
                    } else {
                        CGFloat animationTime = [context transitionDuration] * (1 - [context percentComplete]);
                        [UIView animateWithDuration:animationTime animations:^{
                            CGFloat toAlpha = [coord viewControllerForKey:UITransitionContextToViewControllerKey].barAlpha;
                            [self setNeedsNavigationBackground:toAlpha];
                            UIColor *toColor = [coord viewControllerForKey:UITransitionContextToViewControllerKey].tintColor;
                            [self.navigationBar setTintColor:toColor];
                            
                            UIColor *toBarColor = [coord viewControllerForKey:UITransitionContextToViewControllerKey].barTintColor;
                            [self.navigationBar setBarTintColor:toBarColor];
                        }];
                    }
                }];
            }
        }
    }
}

#pragma mark -
#pragma mark -- -- -- -- -- - UINavigationBarDelegate - -- -- -- -- --
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item {
    [self setNeedsNavigationBackground:self.topViewController.barAlpha];
    [self.navigationBar setTintColor:self.topViewController.tintColor];
    [self.navigationBar setBarTintColor:self.topViewController.barTintColor];
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count >= self.navigationBar.items.count) {
        // back
        if (self.viewControllers.count >= 2) {
            UIViewController *popVC = self.viewControllers[self.viewControllers.count - 2];
            if (popVC) {
                [self setNeedsNavigationBackground:popVC.barAlpha];
                [self.navigationBar setTintColor:popVC.tintColor];
                [self.navigationBar setBarTintColor:popVC.barTintColor];
            }
        }
        [self popViewControllerAnimated:YES];
    }
    return  YES;
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    
}


#pragma mark -
#pragma mark -- -- -- -- -- - override - -- -- -- -- --
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *vc = [super popViewControllerAnimated:animated];
    if (self.interactivePopGestureRecognizer.state != UIGestureRecognizerStateBegan) {
        UIViewController *popVC = self.viewControllers[self.viewControllers.count - 1];
        if (popVC) {
            [self setNeedsNavigationBackground:popVC.barAlpha];
            [self.navigationBar setTintColor:popVC.tintColor];
            [self.navigationBar setBarTintColor:popVC.barTintColor];
        }
    }
    return vc;
}


- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    if (CGRectEqualToRect(self.barBackView.frame, CGRectZero) || !self.barBackView) {
        [self viewWillLayoutSubviews];
    }
    self.barBackView.alpha = alpha;
    self.shadowView.alpha = alpha;
    self.searbarSepView.alpha = alpha;
}

+ (UIColor *)averageColorWithFrome:(UIColor *)color toColor:(UIColor *)to percent:(CGFloat)percent {
    CGFloat fr, fg, fb ,fa;
    CGFloat tr, tg, tb, ta;
    [color getRed:&fr green:&fg blue:&fb alpha:&fa];
    [to getRed:&tr green:&tg blue:&tb alpha:&ta];
    
    CGFloat nowRed = fr + (tr-fr)*percent;
    CGFloat nowGreen = fg + (tg-fg)*percent;
    CGFloat nowBlue = fb + (tb-fb)*percent;
    CGFloat nowAlpha = fa + (ta-fa)*percent;
    return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
    
}


@end
