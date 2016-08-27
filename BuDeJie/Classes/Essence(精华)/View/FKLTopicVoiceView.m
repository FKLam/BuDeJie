//
//  FKLTopicVoiceView.m
//  BuDeJie
//
//  Created by kun on 16/8/27.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicVoiceView.h"
#import "UIImageView+FKLDownload.h"

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
    
    // 设置图片
    [self.imageView fkl_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholderImage:nil];
    
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
