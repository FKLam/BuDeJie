//
//  FKLNewViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLNewViewController.h"
#import "FKLSubTagViewController.h"

@interface FKLNewViewController ()

@end

@implementation FKLNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(leftBarButtonClick)];
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}
#pragma mark - 导航栏左边按钮监听方法
- (void)leftBarButtonClick
{
    // 进入推荐标签界面
    FKLSubTagViewController *subTabVc = [[FKLSubTagViewController alloc] init];
    [self.navigationController pushViewController:subTabVc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
