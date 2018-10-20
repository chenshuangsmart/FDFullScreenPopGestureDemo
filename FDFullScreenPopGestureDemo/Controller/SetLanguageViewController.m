//
//  SetLanguageViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "SetLanguageViewController.h"
#import "AlertUtils.h"

@interface SetLanguageViewController ()
@property(nonatomic, strong)UIButton *btn1;
@property(nonatomic, strong)UIButton *btn2;
@property(nonatomic, strong)UIButton *btn3;
@property(nonatomic, strong)UIButton *btn4;
@property(nonatomic, strong)NSString *appLanguage;
@end

@implementation SetLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.naviTitle = @"系统语言设置";
    
    [self drawUI];
    
    [self setupInit];
}

- (void)drawUI {
    UIButton *btn1 = [self addBtnWithTitle:@"系统语言 - 阿语" action:@selector(setSystemAraibcLanguage)];
    self.btn1 = btn1;
    btn1.y = 20;
    btn1.width = ScreenWidth * 0.4;
    btn1.centerX = ScreenWidth * 0.25;
    [self.containerView addSubview:btn1];

    UIButton *btn2 = [self addBtnWithTitle:@"系统语言 - 英语" action:@selector(setSystemEnglishLanguage)];
    self.btn2 = btn2;
    btn2.y = btn1.y;
    btn2.width = ScreenWidth * 0.4;
    btn2.centerX = ScreenWidth * 0.75;
    [self.containerView addSubview:btn2];

    UIButton *btn3 = [self addBtnWithTitle:@"APP语言 - 阿语" action:@selector(setAppAraibcLanguage)];
    self.btn3 = btn3;
    btn3.y = btn1.bottom + 20;
    btn3.width = ScreenWidth * 0.4;
    btn3.centerX = ScreenWidth * 0.25;
    [self.containerView addSubview:btn3];

    UIButton *btn4 = [self addBtnWithTitle:@"APP语言 - 英语" action:@selector(setAppEnglishLanguage)];
    self.btn4 = btn4;
    btn4.y = btn3.y;
    btn4.width = ScreenWidth * 0.4;
    btn4.centerX = ScreenWidth * 0.75;
    [self.containerView addSubview:btn4];

    UIButton *btn5 = [self addBtnWithTitle:@"设置" action:@selector(set)];
    btn5.y = btn3.bottom + 20;
    btn5.centerX = ScreenWidth * 0.5;
    [self.containerView addSubview:btn5];
}

- (void)setupInit {
    if ([RTLHelper isArabicSystemLanguage]) {
        self.btn1.backgroundColor = [UIColor redColor];
    } else {
        self.btn2.backgroundColor = [UIColor redColor];
    }
    NSString *appLanguage = [[NSUserDefaults standardUserDefaults] valueForKey:AppLanguage];
    if (appLanguage == nil || [appLanguage isEqualToString:EnglishLanguage]) {
        self.btn4.backgroundColor = [UIColor redColor];
        self.appLanguage = EnglishLanguage;
    } else {
        self.btn3.backgroundColor = [UIColor redColor];
        self.appLanguage = ArabicLanguage;
    }
}

#pragma mark - action

- (void)setSystemAraibcLanguage {
    [AlertUtils error:@"请去系统设置语言" duration:2.0];
}

- (void)setSystemEnglishLanguage {
    [AlertUtils error:@"请去系统设置语言" duration:2.0];
}

- (void)setAppAraibcLanguage {
    self.btn3.backgroundColor = [UIColor redColor];
    self.btn4.backgroundColor = [UIColor whiteColor];
    self.appLanguage = ArabicLanguage;
}

- (void)setAppEnglishLanguage {
    self.btn3.backgroundColor = [UIColor whiteColor];
    self.btn4.backgroundColor = [UIColor redColor];
    self.appLanguage = EnglishLanguage;
}

- (void)set {
    [[NSUserDefaults standardUserDefaults] setValue:self.appLanguage forKey:AppLanguage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [RTLHelper initRTL];
    
    MBProgressHUD *hud = [AlertUtils info:@"请稍后" toView:self.containerView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        [RTLHelper setController];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

@end
