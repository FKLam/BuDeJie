//
//  FKLVideoView.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicVideoView.h"
#import "UIImageView+FKLDownload.h"
#import "FKLTopic.h"

@interface FKLTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;
@end

@implementation FKLTopicVideoView

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
    
    if ( 10000 <= topic.playcount )
    {
        NSString *playStr = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
        playStr = [playStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
        self.playcountLabel.text = playStr;
    }
    
    else
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
}
@end
