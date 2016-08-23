//
//  FKLADController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLADViewController.h"
#import <AFNetworking.h>
#import "FKLADItem.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>

#define code2String @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface FKLADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LaunchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;
@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) FKLADItem *item;
@end

@implementation FKLADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置启动图片
    [self setupLaunchImage];
    // 加载广告数据 => 
    [self loadADData];
}
#pragma mark - 设置启动图片
- (void)setupLaunchImage
{
    /*
     6P:LaunchImage-800-Portrait-736h@3x
     6:LaunchImage-800-667h@2x
     5:LaunchImage-568h@2x
     4s:LaunchImage@2x
     */
    NSString *imageName;
    if ( iPhone6p )
    {
        imageName = @"LaunchImage-800-Portrait-736h@3x";
    }
    else if ( iPhone6 )
    {
        imageName = @"LaunchImage-800-667h@2x";
    }
    else if ( iPhone5 )
    {
        imageName = @"LaunchImage-568h@2x";
    }
    else if( iPhone4 )
    {
        imageName = @"LaunchImage@2x";
    }
    self.LaunchImageView.image = [UIImage imageNamed:imageName];
}
/*
 http://mobads.baidu.com/cpro/ui/mads.php?
 code2=phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam
 */
#pragma mark - 加载广告数据
- (void)loadADData
{
    // 创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [mgr.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    NSMutableSet *setM = [NSMutableSet setWithSet:mgr.responseSerializer.acceptableContentTypes];
    [setM addObject:@"text/html"];
    mgr.responseSerializer.acceptableContentTypes = setM;
    // 拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2String;
    __weak typeof( self ) weakSelf = self;
    // 发送请求
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject) {
        // 请求数据 －> 解析数据 －> 展示数据
        // 获取字典
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        // 字典转模型
        FKLADItem *item = [FKLADItem mj_objectWithKeyValues:adDict];
        weakSelf.item = item;
        // 创建UIImageView展示图片 ＝>
        CGFloat h = FKLScreenW / item.w * item.h;
        weakSelf.adView.frame = CGRectMake(0, 0, FKLScreenW, h);
        // 加载广告网页
        [weakSelf.adView sd_setImageWithURL:[NSURL URLWithString:item.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FKLLog(@"%@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 监听点击广告事件
- (void)tap
{
    // 跳转界面 －> safari
    NSURL *url = [NSURL URLWithString:self.item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ( [app canOpenURL:url] )
    {
        [app openURL:url];
    }
}

#pragma mark - getter methods
- (UIImageView *)adView
{
    if ( nil == _adView )
    {
        _adView = [[UIImageView alloc] init];
        [self.adContainView addSubview:_adView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_adView addGestureRecognizer:tap];
        [_adView setUserInteractionEnabled:YES];
    }
    return _adView;
}
@end
