//
//  FKLTopicVoiceView.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicVoiceView.h"
#import "UIImageView+FKLDownload.h"
#import "FKLSeeBigPictureViewController.h"

@interface FKLTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;

@end

@implementation FKLTopicVoiceView

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
    }];
    
    if ( 10000 <= topic.playcount )
    {
        NSString *playStr = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
        playStr = [playStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
        self.playcountLabel.text = playStr;
    }
    
    else
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    self.voicetimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
}
@end
