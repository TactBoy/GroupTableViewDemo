//
//  ViewController.m
//  GroupTableViewDemo
//
//  Created by Gavin on 2018/6/12.
//  Copyright © 2018年 LRanger. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First";

    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}

- (IBAction)pushToMainViewController:(id)sender {
    MainViewController *mainVC = [MainViewController new];
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
