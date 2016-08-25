//
//  FKLFileTool.h
//  BuDeJie
//
//  Created by kun on 16/8/25.
//  Copyright © 2016年 kun. All rights reserved.
//  处理文件缓存

#import <Foundation/Foundation.h>

@interface FKLFileTool : NSObject

/**
*  获取文件夹大小
*
*  @param directoryPath 文件夹路径
*  @param completion    完成时的回调
*/
+ (void)getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;

/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;
@end
