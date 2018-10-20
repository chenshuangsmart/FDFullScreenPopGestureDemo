//
//  BaseNavigationController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "BaseNavigationController.h"
#import "RTLHelper.h"

@interface BaseNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL shouldIgnorePushingViewControllers;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
}

// 做显示的操作
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // self.viewControllers[0]表示根控制器
    if ([viewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        viewController.hidesBottomBarWhenPushed = NO;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // push过程中隐藏tabBar
    if (self.viewControllers.count > 0 && ![viewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    bool remoteConfigOptimizePushTransition = NO;
    // 当前界面显示完成的时候则将 shouldIgnorePushingViewControllers 置为NO.
    // 解决问题.避免同时push相同的界面导致自身添加自身的崩溃.
    // 控制 push 时的方向
    if (!self.shouldIgnorePushingViewControllers) {
        if (remoteConfigOptimizePushTransition && animated) {
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3f;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.type = kCATransitionPush;
            animation.subtype = [RTLHelper isRTL] ? kCATransitionFromLeft : kCATransitionFromRight;
            [self.navigationController.view.layer addAnimation:animation forKey:nil];
            [self.view.layer addAnimation:animation forKey:nil];
            [super pushViewController:viewController animated:NO];
            return;
        }
        [super pushViewController:viewController animated:animated];
    }
    
    self.shouldIgnorePushingViewControllers = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.shouldIgnorePushingViewControllers = NO;
}

@end
