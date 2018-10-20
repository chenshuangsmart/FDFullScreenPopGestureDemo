//
//  UIImage+RTL.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "UIImage+RTL.h"
#import "RTLHelper.h"

@implementation UIImage (RTL)

- (UIImage *)rtl {
    return [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation: UIImageOrientationUpMirrored];
}

-(UIImage *)ifRTLThenOrientationUpMirrored{
    if ([RTLHelper isRTL]) {
        return [self rtl];
    }
    return self;
}

@end
