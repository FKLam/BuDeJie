//
//  FKLTopicPictureView.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicPictureView.h"
#import "UIImageView+FKLDownload.h"
#import "FKLTopic.h"
#import "FKLSeeBigPictureViewController.h"

@interface FKLTopicPictureView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;

@end

@implementation FKLTopicPictureView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}
// 查看大图
- (void)seeBigPicture
{
    FKLSeeBigPictureViewController *seeBigPictureVC = [[FKLSeeBigPictureViewController alloc] init];
    seeBigPictureVC.topic = self.topic;
    [self.window.rootViewController presentViewController:seeBigPictureVC animated:YES completion:nil];
}
- (void)setTopic:(FKLTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderImage.hidden = NO;
    [self.imageView fkl_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( !image ) return;
        self.placeholderImage.hidden = YES;
        // 处理长图片的大小
        if ( topic.isBigPicture )
        {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            // 开启上下文
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0);
            [self.imageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
    }];
    
    // gif
//    if ( [topic.image1.lowercaseString hasSuffix:@"gif"] )
//    if ( [topic.image1.pathExtension.lowercaseString isEqualToString:@"gif"] )
//    {
//        self.gifView.hidden = NO;
//    }
//    else
//    {
//        self.gifView.hidden = YES;
//    }
    self.gifView.hidden = !topic.is_gif;
    
    // 查看大图
    if ( topic.isBigPicture )
    {
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }
    else
    {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.clipsToBounds = NO;
    }
}
@end
