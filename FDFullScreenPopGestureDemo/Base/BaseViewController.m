//
//  BaseViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NaviBarView.h"
#import "HomeViewController.h"
#import "AccountViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setup data
    self.view.backgroundColor = [UIColor whiteColor];
    // 所有界面隐藏导航栏,用自定义的导航栏代替
    self.fd_prefersNavigationBarHidden = YES;
    // drawUI
    [self drawTopNaviBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.navigationBar.height == 0) {
        _topNavBar.alpha = 0;
    }
    // 将导航放到最顶部,不然后面有其它的层会被覆盖
    [self.view bringSubviewToFront:_topNavBar];
}

- (NaviBarView *)topNavBar {
    return _topNavBar;
}

#pragma mark - drawUI

- (void)drawUI {
    
}

/// 在旋转界面时重新构造导航条
- (void)drawTopNaviBar {
    if (_topNavBar) {
        [_topNavBar removeFromSuperview];
    }
    // 添加自定义的导航条
    NaviBarView *naviBar = [[NaviBarView alloc] initWithController:self];
    [self.view addSubview:naviBar];
    self.topNavBar = naviBar;
    
    if (![self isKindOfClass:[HomeViewController class]] && ![self isKindOfClass:[AccountViewController class]]) {
        // 添加返回按钮
        [_topNavBar addBackBtn];
        // 添加底部分割线 - 如果不需要添加,这里处理即可
        [_topNavBar addBottomSepLine];
    }
    
    // 自动放一个容器在下面,如果全屏的界面就往 self.view 加子,非全屏的往 container 加
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
}

- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 100, 50)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [[UIColor grayColor] CGColor];
    btn.layer.borderWidth = 1;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action {
    return [_topNavBar addRightMenu:actionName withAction:action];
}

#pragma mark - 导航条调用

- (void)addScanAndWishList {
    [_topNavBar addScanAndWishList];
}

// 设置导航条透明
- (void)clearNavBarBackgroundColor {
    [_topNavBar clearNavBarBackgroundColor];
}

#pragma mark - set

- (void)setNaviTitle:(NSString *)naviTitle {
    _naviTitle = naviTitle;
    [_topNavBar setNavigationTitle:naviTitle];
}

#pragma mark - action

- (void)doBackPrev {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
