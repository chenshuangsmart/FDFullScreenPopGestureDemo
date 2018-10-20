//
//  RTLHelper.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "RTLHelper.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BaseNavigationController.h"
#import "BaseViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation RTLHelper

static NSNumber *isArabicKay = nil;

/**
 设置视图方向
 1.包括 push 和 pop 时的方向
 2.包括视图布局的方向
 */
+ (void)initRTL {
    //APP阿拉伯语言
    bool isRTL = [RTLHelper isRTL];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0") && isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0") && !isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
}

+ (bool)isArabicSystemLanguage {
    if (!isArabicKay) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        
        NSString *system_prefix_language = @"";
        if ([currentLanguage containsString:@"-"]) {
            NSArray *arr = [currentLanguage componentsSeparatedByString:@"-"];
            system_prefix_language = arr[0];
        } else {
            system_prefix_language = currentLanguage;
        }
        isArabicKay = [NSNumber numberWithBool:[system_prefix_language isEqualToString:@"ar"]];
    }
    return [isArabicKay boolValue];
}

+ (bool)isRTL {
    NSString *language = [[NSUserDefaults standardUserDefaults] valueForKey:AppLanguage];
    if ([language isEqualToString:ArabicLanguage]) {
        return YES;
    }
    return NO;
}

// 新增TabBar后直接处理为重设APP界面
+ (void)setController {
    NSMutableArray *tbViewControllers = [NSMutableArray arrayWithArray:[[IContext getCtx].rootTabBarController viewControllers]];
    for (BaseNavigationController *navVc in tbViewControllers) {
        for (BaseViewController *vc in navVc.childViewControllers) {
            [vc removeFromParentViewController];
        }
    }
    [tbViewControllers removeAllObjects];
    [[IContext getCtx].rootTabBarController setViewControllers:tbViewControllers];

    MainViewController *tb = [[MainViewController alloc] init];
    [IContext getCtx].rootTabBarController = tb;
    [[IContext getCtx].rootWindow setRootViewController:tb];
    [[IContext getCtx].rootWindow makeKeyWindow];
}

@end
