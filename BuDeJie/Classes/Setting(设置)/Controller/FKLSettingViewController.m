//
//  FKLSettingViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLSettingViewController.h"
#import "FKLFileTool.h"
#import <SVProgressHUD.h>

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
static NSString * const ID = @"cell";

@interface FKLSettingViewController ()
@property (nonatomic, assign) NSInteger totalSize;
@end

@implementation FKLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    [SVProgressHUD showWithStatus:@"正在计算缓存大小..."];
    __weak typeof( self ) weakSelf = self;
    [FKLFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        weakSelf.totalSize = totalSize;
        __strong typeof( weakSelf ) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView reloadData];
        });
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( nil == cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [self sizeStr];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [FKLFileTool removeDirectoryPath:CachePath];
    self.totalSize = 0;
    [self.tableView reloadData];
}
- (NSString *)sizeStr
{
    // 计算缓存数据，计算整个应用程序缓存数据 ＝> 沙盒（cache） ＝> 获取cache文件夹大小
    // SDWebImage：帮我们做了缓存
    // 获取default文件路径
    //    NSString *defaultPath = [cachePath stringByAppendingPathComponent:@"default"];
    NSInteger fileSize = self.totalSize;
    NSString *sizeStr = @"清除缓存";
    // MB KB B
    if ( fileSize > 1000 * 1000 )
    {
        CGFloat sizeF = fileSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)", sizeStr, sizeF];
    }
    else if ( fileSize > 1000 )
    {
        CGFloat sizeF = fileSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)", sizeStr, sizeF];
    }
    else if ( fileSize > 0 )
    {
        sizeStr = [NSString stringWithFormat:@"%@(%ldB)", sizeStr, fileSize];
    }
    return sizeStr;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}
@end
