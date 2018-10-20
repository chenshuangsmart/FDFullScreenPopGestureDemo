//
//  IContext.h
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"

@interface IContext : NSObject

@property(retain, nonatomic) MainViewController *rootTabBarController;

/** 主窗体 */
@property(nonatomic, strong)UIWindow *rootWindow;

+ (instancetype)sharedInstance;

+ (IContext *)getCtx;

@end
