//
//  MsgUtil.m
//  CS
//
//  Created by CS on 7/30/18.
//  Copyright (c) 2014 CS. All rights reserved.
//

#import "AlertUtils.h"
#import "AppDelegate.h"

static CGFloat kReadEverySecond = 10;   // 每秒读

@implementation AlertUtils

#pragma mark - success
//显示一个成功的信息
+ (void)success:(NSString *)msg {
    [self success:msg duration:0 toView:nil];
}

+ (void)success:(NSString *)msg duration:(int)duration {
    [self success:msg duration:duration toView:nil];
}

+ (void)success:(NSString *)msg duration:(int)duration toView:(UIView *)toView {
    if (!msg) return;
    return [self bgShowMessage:msg duration:duration toView:toView icon:@"success"];
}

#pragma mark - error

+ (void)error:(NSString *)msg {
    [self error:msg duration:0 toView:nil];
}

+ (void)error:(NSString *)msg duration:(int)duration {
    [self error:msg duration:duration toView:nil];
}

+ (void)error:(NSString *)msg duration:(int)duration toView:(UIView *)toView {
    if (!msg) return;
    return [self bgShowMessage:msg duration:duration toView:toView icon:@"error"];
}

#pragma mark - warning

// 警告提示 - 会自动消失
+ (void)warning:(NSString *)msg {
    [self warning:msg duration:0 toView:nil];
}

+ (void)warning:(NSString *)msg duration:(int)duration {
    [self warning:msg duration:duration toView:nil];
}

+ (void)warning:(NSString *)msg duration:(int)duration toView:(UIView *)toView {
    if (!msg) return;
    [self bgShowMessage:msg duration:duration toView:toView icon:@"caution"];
}

#pragma mark - 文字提示 - 没有图片 - 会自动消失

// 信息提示,没有图片
+ (void)message:(NSString *)msg {
    [self message:msg duration:0 toView:nil];
}

+ (void)message:(NSString *)msg duration:(int)duration {
    [self message:msg duration:duration toView:nil];
}

+ (void)message:(NSString *)msg duration:(int)duration toView:(UIView *)toView {
    if (!msg) return;
    [self bgShowMessage:msg duration:duration toView:toView icon:nil];
}

#pragma mark - info - 带菊花转圈圈

+ (MBProgressHUD *)info:(NSString *)msg {
    return [self showInfo:msg toView:nil];
}

+ (MBProgressHUD *)info:(NSString *)msg toView:(UIView *)toView {
    return [self showInfo:msg toView:toView];
}

#pragma mark - base

// 会自动消失
+ (void)bgShowMessage:(NSString *)msg duration:(int)dura toView:(UIView *)toView icon:(NSString *)icon {
    if (![msg isKindOfClass:[NSString class]] || msg == nil || msg.length == 0) {
        return;
    }
    if (![NSThread isMainThread]) {
        return;
    }
    if (dura == 0) {
        dura = msg.length / kReadEverySecond;
    }
    // 设置停留时间
    dura = dura < 1.5 ? 1.5 : dura;
    dura = dura > 5 ? 5 : dura;
    
    MBProgressHUD *hud;
    if (toView == nil) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    }
    
    hud.margin = 15;
    hud.label.numberOfLines = 0;
    hud.label.text = msg;
    hud.label.font = [UIFont systemFontOfSize:14];
    if (icon != nil) {
        NSString *iconName = [NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        hud.mode = MBProgressHUDModeCustomView;
    } else {
        hud.mode = MBProgressHUDModeText;
    }
    hud.removeFromSuperViewOnHide = true;
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.userInteractionEnabled = NO;    // 即在展示的同时,用户还可以点击其他区域进行交互
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, dura * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

// 不会自动消失 - 带 loading 加载菊花
+ (MBProgressHUD *)showInfo:(NSString *)msg toView:(UIView *)toView{
    if (![msg isKindOfClass:[NSString class]] || msg == nil || msg.length == 0) {
        return nil;
    }
    if (![NSThread isMainThread]) {
        return nil;
    }
    
    MBProgressHUD *hud;
    if (toView == nil) {
        AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
    }
    
    hud.graceTime = 1.2;
    hud.margin = 15;
    hud.label.numberOfLines = 0;
    hud.label.text = msg;
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.removeFromSuperViewOnHide = true;
    hud.contentColor = [UIColor whiteColor];
    hud.backgroundView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    hud.bezelView.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.userInteractionEnabled = YES;
    
    return hud;
}

//有部分特殊的窗体会造成此信息无法显示
+ (MBProgressHUD *)showTopWinMessage:(NSString *)msg duration:(int)duration {
    if (![NSThread isMainThread])
        return nil;
    
    if (![msg isKindOfClass:[NSString class]] || msg == nil || msg.length == 0)
        return nil;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self getTopWindow] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = hud.label.font;
    hud.detailsLabel.text = msg;
    hud.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
    return hud;
}

+(UIWindow *)getTopWindow {
    UIWindow *topWin = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
        return win1.windowLevel - win2.windowLevel;
    }] lastObject];
    return topWin;
}
@end
