//
//  FKLTopicVoiceView.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicVoiceView.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@interface FKLTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *voicetimeLabel;

@end

@implementation FKLTopicVoiceView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
}

- (void)setTopic:(FKLTopic *)topic
{
    _topic = topic;
    
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 在沙盒中取缓存图片
    UIImage *cacheImage1 = [[SDImageCache sharedImageCache]
                            imageFromDiskCacheForKey:topic.image1];
    if ( cacheImage1 )
    {
        self.imageView.image = cacheImage1;
    }
    else
    {
        if ( mgr.isReachableViaWiFi )
        {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image1]];
        }
        else if ( mgr.isReachableViaWWAN )
        {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.image0]];
        }
        else
        {
            // 没有网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:topic.image0];
            if ( thumbnailImage )
            {
                self.imageView.image = thumbnailImage;
            }
            else
                self.imageView.image = nil; // 占位图
        }
    }
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
