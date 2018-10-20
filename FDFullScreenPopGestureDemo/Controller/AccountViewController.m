//
//  AccountViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "AccountViewController.h"
#import "SetLanguageViewController.h"
#import "FirstViewController.h"

@interface AccountViewController ()

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.naviTitle = @"个人中心";
    
    UIButton *btn1 = [self addBtnWithTitle:@"语言设置" action:@selector(setLanguage)];
    btn1.centerX = self.containerView.width * 0.5;
    btn1.y = 10;
    [self.containerView addSubview:btn1];
}

- (void)setLanguage {
    SetLanguageViewController *languageVC = [[SetLanguageViewController alloc] init];
    [self.navigationController pushViewController:languageVC animated:YES];
    
//    FirstViewController *firstVC = [[FirstViewController alloc] init];
//    [self.navigationController pushViewController:firstVC animated:YES];
}

@end
