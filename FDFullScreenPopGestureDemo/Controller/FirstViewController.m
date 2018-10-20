//
//  FirstViewController.m
//  FDFullScreenPopGestureDemo
//
//  Created by cs on 2018/10/20.
//  Copyright © 2018 cs. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.naviTitle = @"First VC";
    
    [self addRightMenu:@"分享" withAction:@selector(tapShare)];
}

- (void)tapShare {
    NSLog(@"分享按钮点击");
}

@end
