//
//  FKLTopicViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/25.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import "FKLTopicCell.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>

@interface FKLTopicViewController ()
/** 网络请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 当前最后一条帖子数据的描述信息，加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 数据量 */
@property (nonatomic, strong) NSMutableArray<FKLTopic *> *topics;
@end

static NSString * const FKLTopicCellID = @"FKLTopicCellID";

@implementation FKLTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    // 设置cell的估算高度（每一行大约都是estimatedRowHeight）
    //    self.tableView.estimatedRowHeight = 44;
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FKLTopicCell class]) bundle:nil] forCellReuseIdentifier:FKLTopicCellID];
    
    // 添加内边距
    self.tableView.contentInset = UIEdgeInsetsMake(FKLNaviMaxY + FKLTitleViewH, 0, FKLTabBarH, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(FKLNaviMaxY + FKLTitleViewH, 0, FKLTabBarH, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonRepeatClick) name:FKLTabBarButtonDidRepeatClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonRepeatClick) name:FKLTitleButtonDidRepeatClickNotification object:nil];
    [self setupRefresh];
}
#pragma mark - 监听通知
- (void)tabBarButtonRepeatClick
{
    if ( nil == self.view.window )
        return;
    if ( NO == self.tableView.scrollsToTop )
        return;
    // 进入下拉刷新
    [self.tableView.mj_header beginRefreshing];
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
#pragma mark - 初始化刷新控件
- (void)setupRefresh
{
    // header
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    // 自动修改透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    // footer
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    
}
#pragma mark - UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 清除内存
    [[SDImageCache sharedImageCache] clearMemory];
}
/**
 *  用户松开scrollView时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}
#pragma mark - 数据处理
/**
 *  发送请求给服务器，下拉刷新数据
 */
- (void)loadNewTopic
{
    // 取消上一次的请求
    if ( 0 < self.manager.tasks.count )
        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.topicType);
    // 发送请求
    [self.manager GET:FKLCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSMutableArray *tempTopics = [FKLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if ( 0 != self.topics.count )
            [self.topics removeAllObjects];
        [self.topics addObjectsFromArray:tempTopics];
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( error.code != NSURLErrorCancelled )
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
/**
 *  发送请求给服务器，上拉加载更多数据数据
 */
- (void)loadMoreTopic
{
    // 取消上一次的请求
    if ( 0 < self.manager.tasks.count )
        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.topicType);
    parameters[@"maxtime"] = self.maxtime;
    // 发送请求
    [self.manager GET:FKLCommonURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.maxtime = responseObject[@"info"][@"maxtime"];
        NSMutableArray *tempTopics = [FKLTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:tempTopics];
        [self.tableView reloadData];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( error.code != NSURLErrorCancelled )
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或者隐藏footer
    NSUInteger count = self.topics.count;
    self.tableView.mj_footer.hidden = ( count == 0 );
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKLTopic *topic = self.topics[indexPath.row];
    FKLTopicCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:FKLTopicCellID];
    cell.topic = topic;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKLTopic *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}
#pragma mark - getter methods
- (NSMutableArray *)topics
{
    if ( nil == _topics )
    {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
- (AFHTTPSessionManager *)manager
{
    if ( nil == _manager )
    {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
- (FKLTopicType)topicType
{
    return FKLTopicTypeAll;
}
@end
