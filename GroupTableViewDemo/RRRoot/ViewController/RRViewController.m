//
//  RRViewController.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "RRViewController.h"
#import <objc/runtime.h>
#import "RRNavigationViewController.h"

@interface RRViewController ()

@end

@implementation RRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


const char key = '\0';

@implementation UIViewController (Alpha)

- (void)setBarAlpha:(CGFloat)barAlpha {
    if (self.navigationController.viewControllers.lastObject != self) {
        return;
    }
    objc_setAssociatedObject(self, @selector(barAlpha), @(barAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self.navigationController isKindOfClass:[RRNavigationViewController class]]) {
        RRNavigationViewController *vc = (RRNavigationViewController *)self.navigationController;
        [vc setNeedsNavigationBackground:barAlpha];
    }
}

- (CGFloat)barAlpha {
    NSNumber *alpha = objc_getAssociatedObject(self, @selector(barAlpha));
    if (!alpha) {
        alpha = @1;
    }
    return [alpha floatValue];
}


- (void)setTintColor:(UIColor *)color {
    if (self.navigationController.viewControllers.lastObject != self) {
        return;
    }
    objc_setAssociatedObject(self, @selector(tintColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController.navigationBar setTintColor:color];
}

- (UIColor *)tintColor {
    UIColor *color = objc_getAssociatedObject(self, @selector(tintColor));
    if (!color) {
        if (self.navigationController.tintColor) {
            self.tintColor = self.navigationController.tintColor;
            return self.navigationController.tintColor;
        }
        color = UIColorHex(2196f3);
    }
    return color;
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    if (self.navigationController.viewControllers.lastObject != self) {
        return;
    }
    objc_setAssociatedObject(self, @selector(barTintColor), barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController.navigationBar setBarTintColor:barTintColor];
}

- (UIColor *)barTintColor {
    UIColor *color = objc_getAssociatedObject(self, @selector(barTintColor));
    return color;
}

- (void)setHiddenBar:(BOOL)hiddenBar {
    objc_setAssociatedObject(self, @selector(hiddenBar), @(hiddenBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNavigationBarHidden:hiddenBar];
}

- (BOOL)hiddenBar {
    NSNumber *hiddenBar = objc_getAssociatedObject(self, @selector(hiddenBar));
    if (!hiddenBar) {
        hiddenBar = @0;
    }
    return [hiddenBar boolValue];
}

- (void)setHiddenBar:(BOOL)hiddenBar animated:(BOOL)animated{
    objc_setAssociatedObject(self, @selector(hiddenBar), @(hiddenBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationController setNavigationBarHidden:hiddenBar animated:animated];
}

@end
