//
//  FKLTabBarController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTabBarController.h"
#import "FKLEssenceViewController.h"
#import "FKLNewViewController.h"
#import "FKLPublishViewController.h"
#import "FKLFriendTrendViewController.h"
#import "FKLMeViewController.h"
#import "UIImage+Image.h"
#import "FKLTabBar.h"
#import "FKLNavigationController.h"

@interface FKLTabBarController ()

@end

@implementation FKLTabBarController

+ (void)load
{
    /*
        appearance
        遵守了UIAppearance协议，还要实现这个方法
        只能在控件显示之前设置，才有效
     */
//    UITabBarItem *item = [UITabBarItem appearance];
    
    // 获取哪个类中UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    // 设置字体尺寸：只有设置正常状态下，才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}

#pragma mark - lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAllChildViewController];
    [self setupAllTitleButton];
    [self setupTabBar];
}

#pragma mark - 添加所有子控制器
- (void)setupAllChildViewController
{
    FKLEssenceViewController *essenceVc = [[FKLEssenceViewController alloc] init];
    [self addChildVC:essenceVc isHasNav:YES];
    
    FKLNewViewController *newVc = [[FKLNewViewController alloc] init];
    [self addChildVC:newVc isHasNav:YES];
    
//    FKLPublishViewController *publishVc = [[FKLPublishViewController alloc] init];
//    [self addChildVC:publishVc isHasNav:NO];
    
    FKLFriendTrendViewController *friendVc = [[FKLFriendTrendViewController alloc] init];
    [self addChildVC:friendVc isHasNav:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([FKLMeViewController class]) bundle:nil];
    // 加载箭头指向控制器
    FKLMeViewController *meVc = [storyboard instantiateInitialViewController];
    [self addChildVC:meVc isHasNav:YES];
}
- (void)addChildVC:(UIViewController *)vc isHasNav:(BOOL)isHasNav
{
    if ( nil == vc )
        return;
    if ( isHasNav )
    {
        FKLNavigationController *nav = [[FKLNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    }
    else
    {
        [self addChildViewController:vc];
    }
}
- (void)setupAllTitleButton
{
    UINavigationController *nav1 = self.childViewControllers[0];
    nav1.tabBarItem.title = @"精华";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    nav1.tabBarItem.selectedImage = [UIImage iamgeOriginalWithName:@"tabBar_essence_click_icon"];
    
    UINavigationController *nav2 = self.childViewControllers[1];
    nav2.tabBarItem.title = @"新帖";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon"];
    nav2.tabBarItem.selectedImage = [UIImage iamgeOriginalWithName:@"tabBar_new_click_icon"];
    
//    FKLPublishViewController *vc = self.childViewControllers[2];
//    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_publish_icon"];
//    vc.tabBarItem.selectedImage = [UIImage iamgeOriginalWithName:@"tabBar_publish_click_icon"];
    
    UINavigationController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.title = @"关注";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav3.tabBarItem.selectedImage = [UIImage iamgeOriginalWithName:@"tabBar_friendTrends_click_icon"];
    
    UINavigationController *nav4 = self.childViewControllers[3];
    nav4.tabBarItem.title = @"我";
    nav4.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav4.tabBarItem.selectedImage = [UIImage iamgeOriginalWithName:@"tabBar_me_click_icon"];
}
- (void)setupTabBar
{
    FKLTabBar *tabBar = [[FKLTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
