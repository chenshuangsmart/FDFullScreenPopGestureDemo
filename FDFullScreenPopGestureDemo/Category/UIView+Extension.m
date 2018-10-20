//
//  UIView+Extension.m
//  AnimationDemo
//
//  Created by cs on 2018/10/6.
//  Copyright © 2018 cs. All rights reserved.
//

#import "UIView+Extension.h"
#import "RTLHelper.h"

#define SCREEN_SCALE                    ([[UIScreen mainScreen] scale])
#define PIXEL_INTEGRAL(pointValue)      (round(pointValue * SCREEN_SCALE) / SCREEN_SCALE)

@implementation UIView (Extension)
@dynamic x, y, width, height, origin, size;

// Setters
-(void)setX:(CGFloat)x{
    self.frame      = CGRectMake(PIXEL_INTEGRAL(x), self.y, self.width, self.height);
}

-(void)setY:(CGFloat)y{
    self.frame      = CGRectMake(self.x, PIXEL_INTEGRAL(y), self.width, self.height);
}

-(void)setWidth:(CGFloat)width{
    self.frame      = CGRectMake(self.x, self.y, PIXEL_INTEGRAL(width), self.height);
}

-(void)setHeight:(CGFloat)height{
    self.frame      = CGRectMake(self.x, self.y, self.width, PIXEL_INTEGRAL(height));
}

-(void)setOrigin:(CGPoint)origin{
    self.x          = origin.x;
    self.y          = origin.y;
}

-(void)setSize:(CGSize)size{
    self.width      = size.width;
    self.height     = size.height;
}

-(void)setRight:(CGFloat)right {
    self.x          = right - self.width;
}

-(void)setBottom:(CGFloat)bottom {
    self.y          = bottom - self.height;
}

-(void)setLeft:(CGFloat)left{
    self.x          = left;
}

-(void)setTop:(CGFloat)top{
    self.y          = top;
}

-(void)setCenterX:(CGFloat)centerX {
    self.center     = CGPointMake(PIXEL_INTEGRAL(centerX), self.center.y);
}

-(void)setCenterY:(CGFloat)centerY {
    self.center     = CGPointMake(self.center.x, PIXEL_INTEGRAL(centerY));
}

// Getters
-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(CGPoint)origin{
    return CGPointMake(self.x, self.y);
}

-(CGSize)size{
    return CGSizeMake(self.width, self.height);
}

-(CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)left{
    return self.x;
}

-(CGFloat)top{
    return self.y;
}

-(CGFloat)centerX {
    return self.center.x;
}

-(CGFloat)centerY {
    return self.center.y;
}

- (void)removeChildByTag:(int)tag {
    UIView *childView = [self viewWithTag:tag];
    if (childView) [childView removeFromSuperview];
}

- (void)onTap:(id)target action:(SEL)sel {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
}

- (CGRect)toRtlFrame:(UIView *)view
{
    CGRect frame = view.frame;
    CGRect superViewFrame = [view superview].frame;
    
    return CGRectMake(superViewFrame.size.width - frame.origin.x - frame.size.width, frame.origin.y, frame.size.width, frame.size.height);
}

- (void)rtlToParent {
    if (![RTLHelper isRTL]) {
        return;
    }
    
    self.frame = [self toRtlFrame:self];
}

@end
