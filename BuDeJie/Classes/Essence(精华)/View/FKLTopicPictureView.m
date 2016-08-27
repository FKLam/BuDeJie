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
}
- (void)setTopic:(FKLTopic *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderImage.hidden = NO;
    [self.imageView fkl_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if ( !image ) return;
        self.placeholderImage.hidden = YES;
    }];
    
    // gif
    
    // 查看大图
    
}
@end
