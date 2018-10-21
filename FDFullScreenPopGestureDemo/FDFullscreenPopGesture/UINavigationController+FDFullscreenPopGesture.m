// The MIT License (MIT)
//
// Copyright (c) 2015-2016 forkingdog ( https://github.com/forkingdog )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UINavigationController+FDFullscreenPopGesture.h"
#import <objc/runtime.h>
#import <MessageUI/MessageUI.h>

#pragma mark - _FDFullscreenPopGestureRecognizerDelegate

@interface _FDFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _FDFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.fd_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    // 设置了一个fd_interactivePopMaxAllowedInitialDistanceToLeftEdge属性用于设置最大左边距，当滑动的x坐标大于它时也是无效的
    CGFloat maxAllowedInitialDistance = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    // 当前是否在转场过程中。这里通过 KVC 拿到了 NavigationController 中的私有 _isTransitioning 属性
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    // 从右往左滑动也是无效的
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : -1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end

#pragma mark - _FDFullRTLScreenPopGestureRecognizerDelegate

@interface _FDFullRTLScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _FDFullRTLScreenPopGestureRecognizerDelegate

// 判断当前界面是否支持手势滑动返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.fd_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    return YES;
}

@end

#pragma mark - _FDViewControllerWillAppearInjectBlock

typedef void (^_FDViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

#pragma mark - UIViewController (FDFullscreenPopGesturePrivate)

@interface UIViewController (FDFullscreenPopGesturePrivate)

@property (nonatomic, copy) _FDViewControllerWillAppearInjectBlock fd_willAppearInjectBlock;

@end

@implementation UIViewController (FDFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        //viewWillAppear
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(fd_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            // 主类本身没有实现需要替换的方法，而是继承了父类的实现，即 class_addMethod 方法返回 YES 。
            // 这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            // 将父类的实现替换到我们自定义的 mrc_viewWillAppear 方法中。这样就达到了在 mrc_viewWillAppear 方法的实现中调用父类实现的目的。
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        //viewWillDisappear
        SEL originalSelector2 = @selector(viewWillDisappear:);
        SEL swizzledSelector2 = @selector(fd_viewWillDisappear:);
        
        Method originalMethod2 = class_getInstanceMethod(class, originalSelector2);
        Method swizzledMethod2 = class_getInstanceMethod(class, swizzledSelector2);
        
        BOOL success2 = class_addMethod(class, originalSelector2, method_getImplementation(swizzledMethod2), method_getTypeEncoding(swizzledMethod2));
        if (success2) {
            class_replaceMethod(class, swizzledSelector2, method_getImplementation(originalMethod2), method_getTypeEncoding(originalMethod2));
        } else {
            method_exchangeImplementations(originalMethod2, swizzledMethod2);
        }
    });
}

- (void)fd_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    // 为了不破坏原本的业务逻辑，先执行原来的viewWillAppear方法
    [self fd_viewWillAppear:animated];
    
    // 执行注入的block 这个block到底干了什么事情，会在后面讲到
    if (self.fd_willAppearInjectBlock) {
        self.fd_willAppearInjectBlock(self, animated);
    }
    
    //设置导航的显示/隐藏
    // 根据导航栏栈顶控制的fd_prefersNavigationBarHidden这个分类属性，- 控制导航栏是否需要隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (void)fd_viewWillDisappear:(BOOL)animated{
    
    [self fd_viewWillDisappear:animated];
    
    //设置导航的显示/隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *vc = [self.navigationController.viewControllers lastObject];
        if (vc.fd_prefersNavigationBarHidden) {
            [self.navigationController setNavigationBarHidden:YES animated:NO];
        } else {
            [self.navigationController setNavigationBarHidden:NO animated:NO];
        }
    });
}

- (_FDViewControllerWillAppearInjectBlock)fd_willAppearInjectBlock
{
    // 1. 调用fd_willAppearInjectBlock属性的get方法的时候
    // 2. 会在本类中以该get方法的名称为key，找到对应的value，也就是该block的值
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFd_willAppearInjectBlock:(_FDViewControllerWillAppearInjectBlock)block
{
    // 1. 当调用了fd_willAppearInjectBlock这个分类属性的set方法时候，
    // 2. 会以block为value 以该属性的get方法为key将block存储起来
    // 3. 以后就可以通过调用fd_willAppearInjectBlock属性的get方法，获取block
    objc_setAssociatedObject(self, @selector(fd_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

#pragma mark - RTLEdgePanGesture

@interface RTLEdgePanGesture : UIScreenEdgePanGestureRecognizer
@end

@implementation RTLEdgePanGesture

// 当手势侧滑时会调用该方法,取到的是手指移动后，在相对坐标中的偏移量
// 注意:如果系统是阿语,手势已经做了特殊处理,所以这个时候使用系统默认的就好
- (CGPoint)translationInView:(UIView *)view {
    if ([RTLHelper isArabicSystemLanguage] && [RTLHelper isRTL]) {
        // APP 为阿语
        return [super translationInView:view];
    }
    if ([UIDevice currentDevice].systemVersion.doubleValue > 9.0) {
        CGPoint oldP = [super translationInView:view];
        // app为阿语  系统不是  反向处理
        return CGPointMake(-oldP.x, oldP.y);
    }
    return [super translationInView:view];
}

@end

#pragma mark - UINavigationController (FDFullscreenPopGesture)

@implementation UINavigationController (FDFullscreenPopGesture)

+ (void)load {
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(fd_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        // 1.这里要注意，class_addMethod是为了检查本类是否实现了这个方法
        // 2.如果方法添加成功，代表本类没有实现该方法（该方法在父类中实现，却没有在子类中实现）
        // 3.如果实现了，那很好，直接交换
        // 4.如果没实现，那么class_addMethod已经把push方法 (对应的实现是fd_push)添加到了本类
        // 5.我们只需要再调用class_replaceMethod方法添加fd_push(对应的实现是push) 添加到本类
        // 6.这样，就达到了方法交换的目的
        // 7.pushViewController:animated: 的内部实现为fd_pushViewController:animated:
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 自定义的手势直接添加到interactivePopGestureRecognizer对应的View上。
    // 实际上就是将系统的手势事件转发为自定义的手势，触发的事件不变
    // doc:http://t.cn/RssK6mz 处理阿语翻转手势
    // 当前APP语言为阿语 || 系统语言为阿语
    if ([RTLHelper isArabicSystemLanguage] || [RTLHelper isRTL]) {
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fd_rtlFullscreenPopGestureRecognizer]) {
            // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fd_rtlFullscreenPopGestureRecognizer];
            
            // Forward the gesture events to the private handler of the onboard gesture recognizer.
            // interactivePopGestureRecognizer会操作一个指定的target , action “handleNavigationTransition”,
            // 通过Runtime动态获取到指定的target, 及action添加到自定义的手势上。
            NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
            // get releate target
            id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
            // get handleNavigationTransition sel
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            self.fd_rtlFullscreenPopGestureRecognizer.delegate = self.fd_popRTLGestureRecognizerDelegate;
            // add target and action to this gesture
            [self.fd_rtlFullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
            
            // Disable the onboard gesture recognizer.
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    } else {
        if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.fd_fullscreenPopGestureRecognizer]) {
            
            // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.fd_fullscreenPopGestureRecognizer];
            
            // Forward the gesture events to the private handler of the onboard gesture recognizer.
            NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
            id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            self.fd_fullscreenPopGestureRecognizer.delegate = self.fd_popGestureRecognizerDelegate;
            [self.fd_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
            
            // Disable the onboard gesture recognizer.
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    
    // Handle perferred navigation bar appearance.
    [self fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    //过滤MessageUI，并且添加取消按钮
    if ([self isKindOfClass:[MFMessageComposeViewController class]]) {
        [self fd_pushViewController:viewController animated:animated];
        [[self.viewControllers lastObject] navigationItem].rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal:)];
        return;
    }
    
    // Forward to primary implementation. 调用父类pushViewController:animated
    if (![self.viewControllers containsObject:viewController]) {
        [self fd_pushViewController:viewController animated:animated];
    }
}

- (void)dismissModal:(UIButton *)sender
{
    [[self.viewControllers lastObject] dismissViewControllerAnimated:YES completion:nil];
}

// 设置当前即将要push的ViewController的当要处理隐藏导航栏时的block
- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.fd_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    // viewWillAppear的时候将会调用该方法，实际上内部也是通过调用setNavigationBarHidden:animated:来设置NavigationBar的显示
    __weak typeof(self) weakSelf = self;
    _FDViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.fd_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.fd_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.fd_willAppearInjectBlock) {
        disappearingViewController.fd_willAppearInjectBlock = block;
    }
}

- (_FDFullscreenPopGestureRecognizerDelegate *)fd_popGestureRecognizerDelegate
{
    // 1.这是我们在1.中第一个提到的类，自定义的pan手势代理，在这个类实现
    // 2.由于该类在判断手势是否满足触发条件时，需要根据导航控制器的情况来做判断
    // 3.所以将导航控制器交给该类引用（记得用weak，不然会循环引用）
    _FDFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[_FDFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)fd_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (_FDFullRTLScreenPopGestureRecognizerDelegate *)fd_popRTLGestureRecognizerDelegate {
    _FDFullRTLScreenPopGestureRecognizerDelegate *rtlDelegate = objc_getAssociatedObject(self, _cmd);
    
    if (!rtlDelegate) {
        rtlDelegate = [[_FDFullRTLScreenPopGestureRecognizerDelegate alloc] init];
        rtlDelegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, rtlDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rtlDelegate;
}

- (UIScreenEdgePanGestureRecognizer *)fd_rtlFullscreenPopGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *rtlPanGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    if (!rtlPanGestureRecognizer) {
        rtlPanGestureRecognizer = [[RTLEdgePanGesture alloc] init];
        rtlPanGestureRecognizer.edges = UIRectEdgeRight;
        if ([RTLHelper isArabicSystemLanguage] && ![RTLHelper isRTL]) {
            // APP 不是阿语,强制把 APP 换成原来的
            rtlPanGestureRecognizer.edges = UIRectEdgeLeft;
        }
        objc_setAssociatedObject(self, _cmd, rtlPanGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rtlPanGestureRecognizer;
}

- (BOOL)fd_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setFd_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(fd_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma mark - UIViewController (FDFullscreenPopGesture)

@implementation UIViewController (FDFullscreenPopGesture)

- (BOOL)fd_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(fd_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fd_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(fd_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)fd_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setFd_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    SEL key = @selector(fd_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
