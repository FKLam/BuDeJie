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

/*
 ［［FKLVideoViewController alloc］init］
 1，FKLVideoViewController.xib
 2，FKLVideoView.xib
 */
@interface FKLEssenceViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *titlesView;
@property (nonatomic, strong) UIScrollView *scrollView;
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
    FKLTopicViewController *allVC = [[FKLAllViewController alloc] init];
    allVC.topicType = FKLTopicTypeAll;
    [self addChildViewController:allVC];
    FKLTopicViewController *videoVC = [[FKLVideoViewController alloc] init];
    videoVC.topicType = FKLTopicTypeVideo;
    [self addChildViewController:videoVC];
    FKLTopicViewController *voiceVC = [[FKLVoiceViewController alloc] init];
    voiceVC.topicType = FKLTopicTypeVoice;
    [self addChildViewController:voiceVC];
    FKLTopicViewController *pictureVC = [[FKLPictureViewController alloc] init];
    pictureVC.topicType = FKLTopicTypePicture;
    [self addChildViewController:pictureVC];
    FKLTopicViewController *wordVC = [[FKLWordViewController alloc] init];
    wordVC.topicType = FKLTopicTypeWord;
    [self addChildViewController:wordVC];
}
- (void)setupScrollView
{
    [self.view addSubview:self.scrollView];
    CGFloat w = self.scrollView.fkl_width;
    NSUInteger count = self.childViewControllers.count;
    self.scrollView.contentSize = CGSizeMake(count * w, 0);
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
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FKLTitleButtonDidRepeatClickNotification object:nil];
//        return;
    }
    [self dealTitleButtonClick:sender];
}
- (void)dealTitleButtonClick:(FKLTitleButton *)sender
{
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
        weakSelf.underLine.fkl_centerX = sender.fkl_centerX;
        weakSelf.scrollView.contentOffset = CGPointMake(sender.tag * weakSelf.scrollView.fkl_width, weakSelf.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        // 添加子控制器的view
        [weakSelf addChildVcViewIntoScrollView:sender.tag];
    }];
    // 设置index位置对应的tableView.scrollToTop ＝ YES，其它都设置为NO
    for ( NSUInteger index = 0; index < self.childViewControllers.count; index++ )
    {
        UIViewController *childVC = self.childViewControllers[index];
        if ( !childVC.isViewLoaded )
            continue;
        UIScrollView *scrollView = (UIScrollView *)childVC.view;
        if ( ![scrollView isKindOfClass:[UIScrollView class]] )
            continue;
        scrollView.scrollsToTop = ( sender.tag == index );
    }
}
#pragma mark - 其它
- (void)addChildVcViewIntoScrollView:(NSInteger)index
{
    UIView *childView = self.childViewControllers[index].view;
    if ( childView.superview )
        return;
    CGFloat scrollViewW = self.scrollView.fkl_width;
    childView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.fkl_height);
    [self.scrollView addSubview:childView];
}
#pragma mark - UIScrollViewDelegate
/**
 *  用户松开手，速度减为 0 时就调用
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.fkl_width;
    FKLTitleButton *titleButton = self.titlesView.subviews[index];
    // 递归查找，包括本身自己
//    FKLTitleButton *titleButton = [self.titlesView viewWithTag:index];
    [self dealTitleButtonClick:titleButton];
}
#pragma mark - getter methods
- (UIScrollView *)scrollView
{
    if ( nil == _scrollView )
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor blueColor];
        _scrollView.frame = self.view.bounds;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}
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
