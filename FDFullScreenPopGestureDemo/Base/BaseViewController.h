//
//  BaseViewController.h
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "NaviBarView.h"
#import "RTLHelper.h"

/**
 基类
 */
@interface BaseViewController : UIViewController

#pragma mark - 导航条相关
@property(nonatomic, copy)NSString *naviTitle;  // 标题
/** 导航条 */
@property(nonatomic, strong)NaviBarView *topNavBar;
/** 内容视图 */
@property (strong, nonatomic) UIView *containerView;

// 返回按钮点击操作
- (void)doBackPrev;

// 扫码和心愿单
- (void)addScanAndWishList;
// 设置导航条透明
- (void)clearNavBarBackgroundColor;

// 添加按钮
- (UIButton *)addBtnWithTitle:(NSString *)title action:(SEL)action;

- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action;

@end

