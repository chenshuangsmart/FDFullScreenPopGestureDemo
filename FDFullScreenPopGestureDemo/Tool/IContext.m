//
//  IContext.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "IContext.h"

static IContext *sharedInstance;

@implementation IContext

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [IContext new];
    });
    return sharedInstance;
}

+ (IContext *)getCtx {
    return sharedInstance;
}

@end
