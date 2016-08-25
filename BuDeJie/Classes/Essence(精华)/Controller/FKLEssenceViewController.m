//
//  FKLEssenceViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLEssenceViewController.h"
#import "FKLTitleButton.h"
#import "FKLAllViewController.h"
#import "FKLPictureViewController.h"
#import "FKLVideoViewController.h"
#import "FKLVoiceViewController.h"
#import "FKLWordViewController.h"

@interface FKLEssenceViewController ()
@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) FKLTitleButton *previousSelectedButton;
@property (nonatomic, strong) UIView *underLine;
@end

@implementation FKLEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavBar];
    [self setupAllChildVCs];
    // scrollView
    [self setupScrollView];
    // 标题栏
    [self setupTitlesView];
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(leftBarButtonClick)];
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(leftBarButtonClick)];
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}
- (void)setupAllChildVCs
{
    [self addChildViewController:[[FKLAllViewController alloc] init]];
    [self addChildViewController:[[FKLPictureViewController alloc] init]];
    [self addChildViewController:[[FKLVideoViewController alloc] init]];
    [self addChildViewController:[[FKLVoiceViewController alloc] init]];
    [self addChildViewController:[[FKLWordViewController alloc] init]];
}
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor blueColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = scrollView.fkl_width;
    CGFloat h = scrollView.fkl_height;
    NSUInteger count = self.childViewControllers.count;
    for ( NSInteger index = 0; index < count; index++ )
    {
        UIView *tableView = self.childViewControllers[index].view;
        x = w * index;
        tableView.frame = CGRectMake(x, y, w, h);
        tableView.backgroundColor = FKLRandomColor;
        [scrollView addSubview:tableView];
    }
    scrollView.contentSize = CGSizeMake(5 * w, 0);
}
- (void)setupTitlesView
{
    [self.view addSubview:self.titlesView];
    [self setupTitleButton];
    [self setupTitleUnderline];
}
- (void)setupTitleButton
{
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    CGFloat y = 0;
    CGFloat x = 0;
    CGFloat w = 1.0 * self.titlesView.fkl_width / count;
    CGFloat h = 1.0 * self.titlesView.fkl_height;
    for ( NSInteger index = 0; index < count; index++ )
    {
        FKLTitleButton *titleButton = [FKLTitleButton buttonWithType:UIButtonTypeCustom];
        x = w * index;
        titleButton.frame = CGRectMake(x, y, w, h);
        [titleButton setTitle:titles[index] forState:UIControlStateNormal];
        [titleButton setTag:index];
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        if ( 0 == index )
            [self titleButtonClick:titleButton];
    }
}
- (void)setupTitleUnderline
{
    [self.titlesView addSubview:self.underLine];
}
#pragma mark - 导航栏左边按钮监听方法
- (void)leftBarButtonClick
{
    
}
- (void)titleButtonClick:(FKLTitleButton *)sender
{
    if ( sender == self.previousSelectedButton )
        return;
    NSTimeInterval duration = 0;
    if ( self.previousSelectedButton )
    {
        [self.previousSelectedButton setSelected:NO];
        duration = 0.25;
    }
    [sender setSelected:YES];
    self.previousSelectedButton = sender;
    __weak typeof( self ) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.underLine.fkl_width = [sender.currentTitle sizeWithAttributes:@{NSFontAttributeName : sender.titleLabel.font}].width + 10;
//        weakSelf.underLine.fkl_width = sender.titleLabel.fkl_width;
        weakSelf.underLine.fkl_centerX = sender.fkl_centerX;
    }];
}
#pragma mark - getter methods
- (UIView *)titlesView
{
    if ( nil == _titlesView )
    {
        _titlesView = [[UIView alloc] init];
        _titlesView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _titlesView.frame = CGRectMake(0, 64, self.view.fkl_width, 35);
    }
    return _titlesView;
}
- (UIView *)underLine
{
    if ( nil == _underLine )
    {
        _underLine = [[UIView alloc] init];
        _underLine.fkl_height = 2;
        _underLine.fkl_y = self.titlesView.fkl_height - _underLine.fkl_height;
        _underLine.fkl_width = 70;
        _underLine.fkl_x = 0;
        _underLine.backgroundColor = [self.previousSelectedButton titleColorForState:UIControlStateSelected];
        _underLine.fkl_centerX = self.previousSelectedButton.fkl_centerX;
    }
    return _underLine;
}
@end
