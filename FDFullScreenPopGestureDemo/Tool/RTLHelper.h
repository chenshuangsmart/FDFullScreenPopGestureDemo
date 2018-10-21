//
//  RTLHelper.h
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IContext.h"

#define AppLanguage @"AppLanguage"
#define ArabicLanguage @"ArabicLanguage"
#define EnglishLanguage @"EnglishLanguage"

@interface RTLHelper : NSObject
// 初始化操作
+ (void)initRTL;
// 系统语言是否是阿与
+ (bool)isArabicSystemLanguage;
// 当前APP是否是阿语环境
+ (bool)isRTL;

+ (void)setController;

@end
