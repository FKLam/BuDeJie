//
//  FKLFriendTrendViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLFriendTrendViewController.h"

@interface FKLFriendTrendViewController ()

@end

@implementation FKLFriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}

#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(leftBarButtonClick)];
    // titleView
    self.navigationItem.title = @"我的关注";
}
#pragma mark - 导航栏左边按钮监听方法
- (void)leftBarButtonClick
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
