//
//  FKLAllViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/25.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLAllViewController.h"

@interface FKLAllViewController ()
@property (nonatomic, strong) UIView *footer;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;
@property (nonatomic, assign) NSInteger dataCount;
@end

@implementation FKLAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.dataCount = 10;
        [self.tableView reloadData];
    });
    // 添加内边距
    self.tableView.contentInset = UIEdgeInsetsMake(FKLNaviMaxY + FKLTitleViewH, 0, FKLTabBarH, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(FKLNaviMaxY + FKLTitleViewH, 0, FKLTabBarH, 0);
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
#pragma mark - 初始化刷新控件
- (void)setupRefresh
{
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
    // 还没有任何内容时，不需要判断
    if ( 0 == self.tableView.contentSize.height ) return;
    // 如果正在刷新，直接返回
    if ( YES == self.isFooterRefreshing ) return;
    // 当scrollView的偏移量y值 >= offsetY时，代表footer已经完全出现
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.fkl_height;
    if ( self.tableView.contentOffset.y >= offsetY )
    {
        // 进入刷新状态
        self.footerRefreshing = YES;
        self.footerLabel.text = @"正在加载更多数据...";
        // 发送请求给服务器
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 服务器请求回来了
            self.dataCount += 5;
            // 结束刷新
            self.footerRefreshing = NO;
            self.footerLabel.text = @"上拉可以加载更多";
            [self.tableView reloadData];
        });
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 根据数据量显示或者隐藏footer
    self.footer.hidden = ( self.dataCount == 0 );
    return self.dataCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( nil == cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *text = [NSString stringWithFormat:@"%@ - %ld", NSStringFromClass([self class]), indexPath.row];
    cell.textLabel.text = text;
    return cell;
}
@end
