//
//  NaviBarView.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "NaviBarView.h"
#import "UIView+Extension.h"
#import "BaseViewController.h"
#import "UIImage+RTL.h"

#define TagRightMenu -300   // 右侧菜单栏
#define TagRightImg -301  // 右侧图片
#define TagLeftClose -302 // 左边关闭按钮
#define TagBackBtn -303   // 左侧返回按钮
#define TagClose -304 // 关闭按钮
#define kTagLine -22    // 底部线条

@implementation NaviBarView {
    __weak BaseViewController *_controller;
    UIView *_statusBar;
    UIView *_navigationBar;
    UIView *_titleView;
    UIButton *_rightWishBtn;
    UIView *_rightMenuView;
    UIButton *_leftMenuBtn;
    UIButton *_leftScanQRCode;  // 左侧二维码扫码
    UIView *_searchBarView;
    UIView *_lineView;
    UIButton *_backBtn;
    UIButton *_closeBtn;
}

- (instancetype)initWithController:(BaseViewController *)controller {
    _controller = controller;
    
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, NavHeight)];
    self.backgroundColor = [UIColor clearColor];
    self.layer.zPosition = 999999;
    
    // 最顶部的状态栏
    _statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, StatusBarHeight)];
    _statusBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_statusBar];
    
    _navigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, ScreenWidth, NavBarHeight)];
    _navigationBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:_navigationBar];

    return self;
}

#pragma mark - get

- (UIView *)navigationBar {
    return _navigationBar;
}

- (UIView *)statusBar {
    return _statusBar;
}

- (UIButton *)rightWishBtn {
    return _rightWishBtn;
}

- (UIButton *)leftMenuBtn {
    return _leftMenuBtn;
}

- (UIButton *)backBtn {
    return _backBtn;
}

#pragma mark - draw

- (void)addBackBtn {
    // 不能添加多个
    UIView *srcBack = [_navigationBar viewWithTag:TagBackBtn];
    if (srcBack)
        return;
    
    UIImage *background = [[UIImage imageNamed:@"nav_back_black"] ifRTLThenOrientationUpMirrored];
    UIImage *backgroundOn = [[UIImage imageNamed:@"nav_back_black"] ifRTLThenOrientationUpMirrored];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setAccessibilityIdentifier:@"TopBackBtn"];
    button.tag = TagBackBtn;
    [button onTap:self action:@selector(doBackPrev)];
    
    [button setImage:background forState:UIControlStateNormal];
    [button setImage:backgroundOn forState:UIControlStateHighlighted];
    
    button.frame = CGRectMake(0, 0, 60, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 20);
    [_navigationBar addSubview:button];
    [button rtlToParent];
    _backBtn = button;
}

//首页分类页用到
- (void)addScanAndWishList {
    if (_leftScanQRCode == nil) {
        UIImage *background = [UIImage imageNamed:@"nav_scan"];
        UIImage *backgroundOn = [UIImage imageNamed:@"nav_scan"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:background forState:UIControlStateNormal];
        [button setImage:backgroundOn forState:UIControlStateSelected];
        [button onTap:self action:@selector(tapScanQRCod)];
        button.frame = CGRectMake(0, 0, 60, 44);
        button.contentEdgeInsets = UIEdgeInsetsMake(7, 10, 7, 20);
        [_navigationBar addSubview:button];
        _leftScanQRCode = button;
    }
    if (_searchBarView == nil) {
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(60, 8, ScreenWidth - 120, 28)];
        searchView.backgroundColor = [UIColor colorWithRed:238 / 255.0 green:238 / 255.0 blue:238 / 255.0 alpha:1];
        searchView.layer.cornerRadius = 12;
        searchView.layer.masksToBounds = YES;
        [_navigationBar addSubview:searchView];
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7.5, 12, 12)];
        searchIcon.image = [UIImage imageNamed:@"ic_smallsearch"];
        [searchView addSubview:searchIcon];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, searchView.width - 60, 28)];
        searchLabel.font = [UIFont systemFontOfSize:14];
        searchLabel.textColor = [UIColor colorWithRed:202 / 255.0 green:202 / 255.0 blue:202 / 255.0 alpha:1];
        searchLabel.text = @"Search";
        [searchView addSubview:searchLabel];
        [searchView onTap:self action:@selector(tapSearch)];
        _searchBarView = searchView;
    }
    if (_rightWishBtn == nil) {
        UIImage *background = [UIImage imageNamed:@"nav_wish_black"];
        UIImage *backgroundOn = [UIImage imageNamed:@"nav_wish_black"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:background forState:UIControlStateNormal];
        [button setImage:backgroundOn forState:UIControlStateSelected];
        
        [button onTap:self action:@selector(tapRightTopWish)];
        
        button.frame = CGRectMake(ScreenWidth - 60, 0, 60, 44);
        button.contentEdgeInsets = UIEdgeInsetsMake(4.5, 15, 4.5, 10);
        
        [_navigationBar addSubview:button];
        _rightWishBtn = button;
    }
}

- (void)addRightWish {
    if (_rightWishBtn) {
        [_rightWishBtn removeFromSuperview];
        _rightWishBtn = nil;
    }
    
    UIImage *background = [UIImage imageNamed:@"ic_home_wishlist_normal"];
    UIImage *backgroundOn = [UIImage imageNamed:@"ic_home_wishlist_highLight"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:background forState:UIControlStateNormal];
    [button setImage:backgroundOn forState:UIControlStateSelected];
    
    [button onTap:self action:@selector(tapRightTopWish)];
    
    button.frame = CGRectMake(_navigationBar.width - 60, 0, 60, 44);
    button.contentEdgeInsets = UIEdgeInsetsMake(4.5, 15, 4.5, 10);
    
    [_navigationBar addSubview:button];
    _rightWishBtn = button;
}

- (void)addBottomSepLine {
    UIView *lineView = [_navigationBar viewWithTag:kTagLine];
    if (lineView) {
        return;
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBar.height - 1, self.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    line.tag = kTagLine;
    _lineView = line;
    [_navigationBar addSubview:line];
}

// 右侧添加按钮
// 添加顶部右边的文字类的按钮
- (UILabel *)addRightMenu:(NSString *)actionName withAction:(SEL)action {
    
    // 当重复添加时,移除旧的按钮
    UILabel *srcLabel = (UILabel *)[_navigationBar viewWithTag:TagRightMenu];
    if (srcLabel) {
        [srcLabel removeFromSuperview];
    }
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 110, 0, 100, 44)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = [UIColor blackColor];
    lb.text = actionName;
    lb.userInteractionEnabled = YES;
    lb.textAlignment = NSTextAlignmentRight;
    lb.tag = TagRightMenu;
    [lb onTap:_controller action:action];
    [_navigationBar addSubview:lb];
    [lb rtlToParent];
    _rightMenuView = lb;
    return lb;
}
#pragma mark - set

- (void)clearNavBarBackgroundColor {
    _statusBar.backgroundColor = [UIColor clearColor];
    _navigationBar.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [_navigationBar removeChildByTag:kTagLine];
}

- (void)setNavigationTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setBackImage:(NSString *)imageName {
    UIImage *background = [UIImage imageNamed:imageName];
    UIImage *backgroundOn = [UIImage imageNamed:imageName];
    [_backBtn setImage:background forState:UIControlStateNormal];
    [_backBtn setImage:backgroundOn forState:UIControlStateHighlighted];
}

#pragma mark - action

- (void)doBackPrev {
    if (_controller)
        [_controller doBackPrev];
}

- (void)tapScanQRCod {
    
}

- (void)tapSearch {
    
}

- (void)tapRightTopWish {
    
}

- (void)dealloc {
    if (_rightMenuView) _rightMenuView = nil;
    if (_rightWishBtn) _rightWishBtn = nil;
    if (_leftMenuBtn) _leftMenuBtn = nil;
    if (_backBtn) _backBtn = nil;
    if (_closeBtn) _closeBtn = nil;
    if (_searchBarView) _searchBarView = nil;
}

#pragma mark - lazy

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, ScreenWidth - 120, 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_navigationBar addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
