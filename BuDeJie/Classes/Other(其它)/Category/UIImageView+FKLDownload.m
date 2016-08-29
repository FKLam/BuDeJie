//
//  UIImageView+FKLDownload.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UIImageView+FKLDownload.h"
#import <AFNetworking.h>
#import "UIImage+Image.h"

@implementation UIImageView (FKLDownload)
- (void)fkl_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock
{
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 在沙盒中取缓存图片
    UIImage *cacheImage1 = [[SDImageCache sharedImageCache]
                            imageFromDiskCacheForKey:originImageURL];
    if ( cacheImage1 )
    {
//        self.image = cacheImage1;
//        completedBlock(cacheImage1, nil, 0, [NSURL URLWithString:originImageURL]);
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] completed:completedBlock];
    }
    else
    {
        if ( mgr.isReachableViaWiFi )
        {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] completed:completedBlock];
        }
        else if ( mgr.isReachableViaWWAN )
        {
            [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] completed:completedBlock];
        }
        else
        {
            // 没有网络
            UIImage *cacheThumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if ( cacheThumbnailImage )
            {
//                self.image = cacheThumbnailImage;
//                completedBlock( cacheThumbnailImage, nil, 0, [NSURL URLWithString:thumbnailImageURL]);
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] completed:completedBlock];
            }
            else
            {
//                self.image = placeholderImage; // 占位图
                [self sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];
            }
        }
    }
}
- (void)fkl_setCircleHeader:(NSString *)headerURL
{
    [self sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage fkl_circleImageName:@"defaultUserIcon"]  options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败 直接返回 按照它的默认做法
        if ( !image ) return;
        
        self.image = [image fkl_circleImage];
    }];
}
@end
