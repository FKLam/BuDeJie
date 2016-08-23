//
//  FKLSubTagViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLSubTagViewController.h"
#import <AFNetworking.h>
#import "FKLSubTagItem.h"
#import <MJExtension.h>

@interface FKLSubTagViewController ()
@property (nonatomic, strong) NSMutableArray *subTags;
@end

@implementation FKLSubTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 展示标签数据 －> 请求数据（接口文档）
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData
{
    // 创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    __weak typeof( self ) weakSelf = self;
    // 发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * _Nullable responseObject) {
        
        NSArray *tempArray = [FKLSubTagItem mj_objectArrayWithKeyValuesArray:responseObject];
        [weakSelf.subTags addObjectsFromArray:tempArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FKLLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subTags.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    // 自定义cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( nil == cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 获取模型
    FKLSubTagItem *item = self.subTags[indexPath.row];
    cell.textLabel.text = item.theme_name;
    return cell;
}
#pragma mark - getter methods
- (NSMutableArray *)subTags
{
    if ( nil == _subTags )
    {
        _subTags = [NSMutableArray array];
    }
    return _subTags;
}
@end
