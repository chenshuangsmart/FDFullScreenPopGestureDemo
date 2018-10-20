//
//  UIView+Extension.h
//  AnimationDemo
//
//  Created by cs on 2018/10/6.
//  Copyright © 2018 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
/** View's X Position */
@property (nonatomic, assign) CGFloat   x;

/** View's Y Position */
@property (nonatomic, assign) CGFloat   y;

/** View's width */
@property (nonatomic, assign) CGFloat   width;

/** View's height */
@property (nonatomic, assign) CGFloat   height;

/** View's origin - Sets X and Y Positions */
@property (nonatomic, assign) CGPoint   origin;

/** View's size - Sets Width and Height */
@property (nonatomic, assign) CGSize    size;

/** Y value representing the bottom of the view **/
@property (nonatomic, assign) CGFloat   bottom;

/** X Value representing the right side of the view **/
@property (nonatomic, assign) CGFloat   right;

/** X Value representing the top of the view (alias of x) **/
@property (nonatomic, assign) CGFloat   left;

/** Y Value representing the top of the view (alias of y) **/
@property (nonatomic, assign) CGFloat   top;

/** X value of the object's center **/
@property (nonatomic, assign) CGFloat   centerX;

/** Y value of the object's center **/
@property (nonatomic, assign) CGFloat   centerY;

- (void)removeChildByTag:(int)tag;

- (void)onTap:(id)target action:(SEL)sel;

- (CGRect)toRtlFrame:(UIView *)view;

- (void)rtlToParent;

@end
