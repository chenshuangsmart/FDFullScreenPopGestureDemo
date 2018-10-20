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

+ (void)initRTL;

+ (bool)isArabicSystemLanguage;

+ (bool)isRTL;

+ (void)setController;

@end
