//
//  SecondViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.naviTitle = @"隐藏导航条分割线";
    [self clearNavBarBackgroundColor];
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.backgroundColor = [UIColor redColor];
//    scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight * 2);
//    [self.view addSubview:scrollView];
}



@end
