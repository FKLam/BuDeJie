//
//  FKLFileTool.m
//  BuDeJie
//
//  Created by kun on 16/8/25.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLFileTool.h"

@implementation FKLFileTool
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion
{
    // NSFileManager
    // attributesOfItemAtPath：指定文件路径，就能获取文件属性
    // 把所有文件尺寸加起来
    // 获取cache文件夹路径
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if ( !isExist || !isDirectory )
    {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"本当 需要传入的是文件夹路径，并且路径存在" userInfo:nil];
        [excp raise];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获取文件夹下所有的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        NSInteger fileSize = 0;
        for ( NSString *subPath in subPaths )
        {
            // 获取文件全路径
            NSString *filePatch = [directoryPath stringByAppendingPathComponent:subPath];
            // 判断是否隐藏文件
            if ( [filePatch rangeOfString:@".DS"].location != NSNotFound )
                continue;
            // 判断是否文件夹
            BOOL isDirectory;
            BOOL isExist = [mgr fileExistsAtPath:filePatch isDirectory:&isDirectory];
            if ( !isExist || isDirectory )
                continue;
            // 获取文件属性
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePatch error:nil];
            
            // default大小
            fileSize += [attr fileSize];
        }
        // 计算完成
        if ( completion )
        {
            completion(fileSize);
        }
    });
}
+ (void)removeDirectoryPath:(NSString *)directoryPath
{
    // 清空缓存
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    // 判断是否文件夹
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    if ( !isExist || !isDirectory )
    {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"本当 需要传入的是文件夹路径，并且路径存在" userInfo:nil];
        [excp raise];
    }
    // 获取cache文件夹下所有文件,不包括子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    for ( NSString *subPath in subPaths )
    {
        // 拼接完全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }
}
@end
