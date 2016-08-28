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

@interface FKLTopicViewController ()
/** 网络请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 当前最后一条帖子数据的描述信息，加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
/** 下拉刷新控件 */
@property (nonatomic, strong) UIView *header;
/** 下拉刷新控件里面的文字 */
@property (nonatomic, strong) UILabel *headerLabel;
/** 下拉刷新控件是否正在刷新标示 */
@property (nonatomic, assign, getter=isHeaderRefreshing) BOOL headerRefreshing;
/** 上拉刷新控件 */
@property (nonatomic, strong) UIView *footer;
/** 上拉刷新控件里面的文字 */
@property (nonatomic, strong) UILabel *footerLabel;
/** 上拉刷新控件是否正在刷新标示 */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
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
    [self headerBeginRefreshing];
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
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, -50, self.tableView.fkl_width, 50);
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.frame = header.bounds;
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.text = @"下拉可以刷新";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:headerLabel];
    self.header = header;
    self.headerLabel = headerLabel;
    [self.tableView addSubview:self.header];
    [self headerBeginRefreshing];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, self.tableView.fkl_width, 35);
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.frame = footer.bounds;
    footerLabel.backgroundColor = [UIColor redColor];
    footerLabel.text = @"上拉可以加载更多";
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    [footer addSubview:footerLabel];
    self.tableView.tableFooterView = footer;
    self.footer = footer;
    self.footerLabel = footerLabel;
}
#pragma mark - UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 处理header
    [self dealHeader];
    
    // 处理footer
    [self dealFooter];
    
    // 清除内存
    [[SDImageCache sharedImageCache] clearMemory];
}
/**
 *  用户松开scrollView时调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetY = -( self.tableView.contentInset.top + self.header.fkl_height );
    if ( self.tableView.contentOffset.y <= offsetY )
    {
        [self headerBeginRefreshing];
    }
}
// 处理header
- (void)dealHeader
{
    // 如果正在下拉刷新，直接返回
    if ( self.isHeaderRefreshing == YES ) return;
    CGFloat offsetY = -( self.tableView.contentInset.top + self.header.fkl_height );
    if ( self.tableView.contentOffset.y <= offsetY )
    {
        self.headerLabel.text = @"松开立即刷新";
    }
    else
    {
        self.headerLabel.text = @"下拉可以刷新";
    }
}
// 处理footer
- (void)dealFooter
{
    // 还没有任何内容时，不需要判断
    if ( 0 == self.tableView.contentSize.height ) return;
    // 如果正在刷新，直接返回
    if ( YES == self.isFooterRefreshing ) return;
    // 当scrollView的偏移量y值 >= offsetY时，代表footer已经完全出现
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.fkl_height;
    if ( self.tableView.contentOffset.y >= offsetY  &&
        self.tableView.contentOffset.y > - ( self.tableView.contentInset.top ))
    {
        // 进入刷新状态
        [self footerBeginRefreshing];
    }
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
        [self headerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( error.code != NSURLErrorCancelled )
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        [self headerEndRefreshing];
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
        [self footerEndRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ( error.code != NSURLErrorCancelled )
            [SVProgressHUD showErrorWithStatus:@"网络繁忙"];
        [self footerEndRefreshing];
    }];
}
#pragma mark - header
- (void)headerBeginRefreshing
{
    //    if ( YES == self.isFooterRefreshing ) return;
    if ( YES == self.isHeaderRefreshing ) return;
    self.headerRefreshing = YES;
    self.headerLabel.text = @"正在刷新数据...";
    // 增加内边距
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top += self.header.fkl_height;
        self.tableView.contentInset = inset;
        // 修改偏移量
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, -inset.top);
    }];
    // 发送刷新数据请求
    [self loadNewTopic];
}
- (void)headerEndRefreshing
{
    self.headerRefreshing = NO;
    [UIView animateWithDuration:0.25 animations:^{
        UIEdgeInsets inset = self.tableView.contentInset;
        inset.top -= self.header.fkl_height;
        self.tableView.contentInset = inset;
    }];
    self.headerLabel.text = @"下拉可以刷新";
}
#pragma mark - footer
- (void)footerBeginRefreshing
{
    //    if ( YES == self.isHeaderRefreshing ) return;
    if ( YES == self.isFooterRefreshing ) return;
    self.footerRefreshing = YES;
    self.footerLabel.text = @"正在加载更多数据...";
    // 发送请求给服务器
    [self loadMoreTopic];
}
- (void)footerEndRefreshing
{
    self.footerRefreshing = NO;
    self.footerLabel.text = @"上拉可以加载更多";
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或者隐藏footer
    NSUInteger count = self.topics.count;
    self.footer.hidden = ( count == 0 );
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
@end
