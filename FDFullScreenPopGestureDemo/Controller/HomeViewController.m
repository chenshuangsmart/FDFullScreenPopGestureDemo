//
//  HomeViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "HomeViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加扫码,搜索,心愿单
    [self addScanAndWishList];
    
    // 添加按钮
    [self addBtn];
}

#pragma mark - drawUI

- (void)addBtn {
    UIButton *btn1 = [self addBtnWithTitle:@"正常情况" action:@selector(firstVC)];
    btn1.centerX = self.containerView.width * 0.5;
    btn1.y = 10;
    [self.containerView addSubview:btn1];
    
    UIButton *btn2 = [self addBtnWithTitle:@"没有分割线" action:@selector(secondVC)];
    btn2.centerX = self.containerView.width * 0.5;
    btn2.y = btn1.bottom + 10;
    [self.containerView addSubview:btn2];
}

#pragma mark - action

- (void)firstVC {
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:firstVC animated:YES];
}

- (void)secondVC {
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

@end
