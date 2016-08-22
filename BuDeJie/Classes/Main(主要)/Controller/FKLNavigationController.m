//
//  FKLNavigationController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLNavigationController.h"

@interface FKLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation FKLNavigationController
+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    // 设置导航条标题 ＝> UINavigationBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 解决左滑手势失效
    // 控制手势什么时候触发，只有非根控制器才需要出发手势
    self.interactivePopGestureRecognizer.delegate = self;
    // 假死状态：程序还在运行，但是界面死了
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [self.childViewControllers count] > 0 )
    {
        // 恢复滑动返回功能 －> 分析：把系统的返回按钮覆盖 －> 手势失效（手势被清空，可能手势代理做了一些事情，导致手势失效）
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
    // 真正跳转
    [super pushViewController:viewController animated:YES];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
#pragma mark - UIGestureRecognizerDelegate
// 决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
