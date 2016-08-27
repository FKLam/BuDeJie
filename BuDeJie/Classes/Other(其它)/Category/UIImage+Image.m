//
//  UIImage+Image.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
+ (instancetype)iamgeOriginalWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (instancetype)fkl_circleImage
{
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 设置裁剪区域
    [path addClip];
    // 画图片
    [self drawAtPoint:CGPointZero];
    // 取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}
+ (instancetype)fkl_circleImageName:(NSString *)name
{
    return [[self imageNamed:name] fkl_circleImage];
}
@end
