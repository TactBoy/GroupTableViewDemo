//
//  MainViewController.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "MainViewController.h"
#import "RRGroupView.h"
#import "RRButton.h"
#import "RRTableVIew.h"
#import "RRGroupHeaderView.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) RRTableVIew *tableView1;
@property(nonatomic, strong) RRTableVIew *tableView2;
@property(nonatomic, strong) RRTableVIew *tableView3;
@property(nonatomic, strong) RRGroupView *groupView;

@property(nonatomic, strong) UIView *headerView;

@property(nonatomic, strong) UIView *indicatorView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView1 = [self generateTableView];
    _tableView1.name = @"_tableView1";
    
    _tableView2 = [self generateTableView];
    _tableView2.name = @"_tableView2";
    
    _tableView3 = [self generateTableView];
    _tableView3.name = @"_tableView3";
    
    _headerView = [RRGroupHeaderView new];
    _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _headerView.height = 200;
    
    RRButton *button = [RRButton new];
    button.name = @"Button";
    [button addTarget:self action:@selector(pressAvatar) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 30;
    button.layer.masksToBounds = YES;
    button.size = CGSizeMake(60, 60);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 0.5;
    [button setImage:[UIImage imageNamed:@"ic-people"] forState:UIControlStateNormal];
    button.center = CGPointMake(self.view.width / 2, _headerView.height / 2);
    [_headerView addSubview:button];

    
    _groupView = [[RRGroupView alloc] initWithFrame:self.view.bounds];
    _groupView.stickValue = [UIApplication sharedApplication].statusBarFrame.size.height + 44 + 20;
    _groupView.restoreWhenIndexChange = NO;
    [_groupView reloadWithTableViews:@[_tableView1, _tableView2, _tableView3] headerView:_headerView prefrredIndex:0];
    [self.view addSubview:_groupView];
    
    @weakify(self);
    [_groupView setHeaderHiddenProgressDidChange:^(CGFloat progress) {
        @strongify(self);
        self.barAlpha = progress;
    }];
    
    [_groupView setCurrentIndexDidChange:^(NSInteger currentIndex) {
        NSLog(@"currentIndex change: %ld", currentIndex);
    }];
    
    [_groupView setCurrentIndexValueDidChange:^(CGFloat currentIndexValue) {
        @strongify(self);
//        NSLog(@"currentIndexValue change: %f", currentIndexValue);
        [self updateIndicatorView:currentIndexValue];
    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.groupView setCurrentIndex:1 animated:YES];
//    });
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.barAlpha = 0;
    [self updateIndicatorView:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)updateIndicatorView:(CGFloat)index {
    if (!self.indicatorView) {
        self.indicatorView = [UIView new];
        _indicatorView.layer.cornerRadius = 4;
        _indicatorView.backgroundColor = UIColorHex(2196f3);
        [self.headerView addSubview:_indicatorView];
    }
    _indicatorView.size = CGSizeMake(60, 4);
    _indicatorView.center = CGPointMake(self.view.width / 4 * (1 + index), self.headerView.height - 10);
}

- (RRTableVIew *)generateTableView {
    RRTableVIew *tableView = [[RRTableVIew alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 44;
    tableView.contentInset = UIEdgeInsetsMake(20 + (arc4random() % 20), 0, 0, 0);
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    tableView.delaysContentTouches = NO;
    return tableView;
}

- (void)pressAvatar {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"" message:@"🤣🤣🤣🤣" preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark -
#pragma mark -- -- -- -- -- - UITableView Delegate & DataSource - -- -- -- -- --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"_empty"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"_empty"];
    }
    if (tableView == _tableView1) {
        cell.textLabel.text = [NSString stringWithFormat:@"_tableView1 这是第 %ld 行", indexPath.row];
    } else if (tableView == _tableView2) {
        cell.textLabel.text = [NSString stringWithFormat:@"_tableView2 这是第 %ld 行", indexPath.row];
    } if (tableView == _tableView3) {
        cell.textLabel.text = [NSString stringWithFormat:@"_tableView3 这是第 %ld 行", indexPath.row];
    }
    cell.textLabel.textColor = [self.class randomColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}


+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
