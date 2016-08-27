//
//  UIImageView+FKLDownload.h
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FKLDownload)
- (void)fkl_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage;
- (void)fkl_setCircleHeader:(NSString *)headerURL;
@end
