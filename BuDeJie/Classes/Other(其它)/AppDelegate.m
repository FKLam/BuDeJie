//
//  AppDelegate.m
//  BuDeJie
//
//  Created by kun on 16/8/21.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "AppDelegate.h"
#import "FKLADViewController.h"
#import <AFNetworking.h>
// 每次程序启动的时候进入广告界面
/*
 1，在启动的时候，去加个广告界面
 2，启动完成的时候，加个广告界面（展示了启动图片）
    1，程序一启动就进入广告界面，窗口的根控制器设置为广告控制器 ✅
    2，直接往窗口上再加上一个广告界面，等几秒过去了，在把广告界面移除
 */
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口根控制器
    FKLADViewController *adVc = [[FKLADViewController alloc] init];
    // init -> initWithNibName 1,首先判断有没有指定nibName，2,判断下有没有跟类名同名xib
    self.window.rootViewController = adVc;
    // 显示窗口，成为主窗口
    [self.window makeKeyAndVisible];
    // 监听网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
