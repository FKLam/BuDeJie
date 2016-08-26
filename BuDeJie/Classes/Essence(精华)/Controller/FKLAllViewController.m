//
//  FKLAllViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/25.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLAllViewController.h"

@interface FKLAllViewController ()

@end

@implementation FKLAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加内边距
    self.tableView.contentInset = UIEdgeInsetsMake(FKLNaviMaxY + FKLTitleViewH, 0, FKLTabBarH, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonRepeatClick) name:FKLTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonRepeatClick) name:FKLTitleButtonDidRepeatClickNotification object:nil];
    
}
#pragma mark - 监听通知
- (void)tabBarButtonRepeatClick
{
    if ( nil == self.view.window )
        return;
    if ( NO == self.tableView.scrollsToTop )
        return;
    FKLLog(@"%s", __func__);
}
- (void)titleButtonRepeatClick
{
    [self tabBarButtonRepeatClick];
}
#pragma mark - 控制器销毁时调用的方法
- (void)dealloc
{
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

@end
