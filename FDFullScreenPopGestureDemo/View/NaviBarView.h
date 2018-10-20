//
//  NaviBarView.h
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController;

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44
#define NavHeight (StatusBarHeight + NavBarHeight)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 导航条
 */
@interface NaviBarView : UIView

@property (retain, nonatomic) UIView *statusBar;    // 状态栏
@property (retain, nonatomic) UIView *navigationBar;    // 导航条
@property (retain, nonatomic) UIButton *rightWishBtn;   // 右侧分享按钮
@property (retain, nonatomic) UIButton *leftMenuBtn;    // 左侧菜单栏
@property (retain, nonatomic) UIButton *backBtn;    // 返回按钮
@property (retain, nonatomic) UILabel *titleLabel;  // 标题
@property(nonatomic, strong)UIView *lineView;   // 底部分割线

- (instancetype)initWithController:(BaseViewController *)controller;

// 扫码和心愿单
- (void)addScanAndWishList;
// 添加返回按钮
- (void)addBackBtn;
// 添加白色图标返回按钮
- (void)addWhiteBack;
// 添加底部分割线
- (void)addBottomSepLine;
// 设置标题
- (void)setNavigationTitle:(NSString *)title;
// 设置导航条透明
- (void)clearNavBarBackgroundColor;

// 右侧添加按钮
- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action;

@end
