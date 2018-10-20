//
//  MainViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BaseNavigationController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.fd_prefersNavigationBarHidden = YES;
    [self addChildVC];
}

- (void)addChildVC {
    // 创建子控制器
    HomeViewController *homeVC=[[HomeViewController alloc] init];
    [self setTabBarItem:homeVC.tabBarItem
                  title:@"首页"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"tab_home_pre"
     selectedTitleColor:[UIColor orangeColor]
            normalImage:@"tab_home_nor"
       normalTitleColor:[UIColor grayColor]];
    
    AccountViewController *accountVC=[[AccountViewController alloc] init];
    [self setTabBarItem:accountVC.tabBarItem
                  title:@"个人"
              titleSize:13.0
          titleFontName:@"HeiTi SC"
          selectedImage:@"tab_myaccount_pre"
     selectedTitleColor:[UIColor orangeColor]
            normalImage:@"tab_myaccount_nor"
       normalTitleColor:[UIColor grayColor]];
    
    BaseNavigationController *homeNV = [[BaseNavigationController alloc] initWithRootViewController:homeVC];
    BaseNavigationController *accountNV = [[BaseNavigationController alloc] initWithRootViewController:accountVC];
    // 把子控制器添加到UITabBarController
    self.viewControllers = @[homeNV, accountNV];
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor {
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}

@end
