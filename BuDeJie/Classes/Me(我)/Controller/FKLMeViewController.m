//
//  FKLMeViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLMeViewController.h"
#import "FKLSettingViewController.h"
#import "FKLSquareCell.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "FKLSquareItem.h"
#import <SafariServices/SafariServices.h>
#import "FKLWebViewController.h"

static NSString * const ID = @"cell";
static NSInteger const cols = 4;
static CGFloat const margin = 1.0;
#define itemH (( FKLScreenW - ( cols - 1 ) * margin ) / cols)

@interface FKLMeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *squareItems;
@end

@implementation FKLMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    // 设置tableView底部视图
    [self setupFootView];
    // 展示方块的内容
    [self loadData];
    /*
     细节：
     1，collectionView高度重新计算 => collectionView高度需要跟进内容去计算 =>
     2，collectionView不需要滚动
     */
    // 处理cell间距，默认tableView分组样式，有额外头部和尾部间距
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10.0;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 右边按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(settingButtonClick)];
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(nightButtonClick:)];
    self.navigationItem.rightBarButtonItems = @[settingItem, nightItem];
    // titleView
    self.navigationItem.title = @"我的";
}
#pragma mark - 导航栏右边按钮监听方法
- (void)settingButtonClick
{
    // 跳转到设置界面
    FKLSettingViewController *settingVc = [[FKLSettingViewController alloc] init];
    // 必须在跳转之前设置
    settingVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVc animated:YES];
}
- (void)nightButtonClick:(UIButton *)button
{
    button.selected = !button.isSelected;
}
#pragma mark - 设置tableView底部视图
- (void)setupFootView
{
    /*
     1，初始化要设置流水布局
     2，cell必须要注册
     3，cell必须自定义
     */
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemH, itemH);
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionView.backgroundColor = self.tableView.backgroundColor;
    self.tableView.tableFooterView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册cell
    [collectionView registerNib:[UINib nibWithNibName:@"FKLSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    collectionView.scrollEnabled = NO;
    self.collectionView = collectionView;
}
#pragma mark - 请求数据
- (void)loadData
{
    // 创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 拼接请求参数
    NSMutableDictionary *parmaters = [NSMutableDictionary dictionary];
    parmaters[@"a"] = @"square";
    parmaters[@"c"] = @"topic";
    __weak typeof( self ) weakSelf = self;
    // 发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parmaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        // name url icon
        NSArray *dictArr = responseObject[@"square_list"];
        NSArray *squareItems = [FKLSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        [weakSelf.squareItems addObjectsFromArray:squareItems];
        [weakSelf resloveData];
        // 设置collectionView 计算高度 ＝ rows ＊ itemH
        // rows ＝ （count － 1）／ cols ＋ 1
        NSInteger count = weakSelf.squareItems.count;
        NSInteger rows = (count - 1) / cols + 1;
        weakSelf.collectionView.fkl_height = rows * itemH;
        weakSelf.tableView.tableFooterView = weakSelf.collectionView;
        [weakSelf.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FKLLog(@"%@", error);
    }];
}
#pragma mark - 处理请求完成数据
- (void)resloveData
{
    NSInteger count = self.squareItems.count;
    NSInteger exter = count % cols;
    if ( !exter )
    {
        return;
    }
    exter = cols - exter;
    for ( NSInteger index = 0; index < exter; index++ )
    {
        FKLSquareItem *squareItem = [[FKLSquareItem alloc] init];
        [self.squareItems addObject:squareItem];
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.squareItems.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FKLSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.squareItem = self.squareItems[indexPath.item];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 跳转网页
    /*
     1，safari openURL：自带很多功能（进度条，刷新，前进，倒退等等功能），必须跳出当前应用
     2，UIWebView （没有功能）在当前应用打开网页，并且有safari，自己实现，UIWebView不能实现进度条
     3，需求：既要在当前应用展示网页，又要safari的功能
        导入SafariServices iOS9才能使用
     4，WKWebView（iOS） UIWebView的升级版
     */
    FKLSquareItem *squareItem = self.squareItems[indexPath.item];
    if ( [squareItem.url rangeOfString:@"http"].location == NSNotFound )
        return;
    // SFSafariViewController 推荐使用Modal
//    SFSafariViewController *safariVc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:squareItem.url]];
//    [self presentViewController:safariVc animated:YES completion:nil];
    NSURL *url = [NSURL URLWithString:squareItem.url];
    FKLWebViewController *webView = [[FKLWebViewController alloc] init];
    webView.url = url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - getter methods
- (NSMutableArray *)squareItems
{
    if ( nil == _squareItems )
    {
        _squareItems = [NSMutableArray array];
    }
    return _squareItems;
}
@end
