//
//  FKLTopicCell.m
//  BuDeJie
//
//  Created by kun on 16/8/26.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopicCell.h"
#import <UIImageView+WebCache.h>
#import "UIImage+Image.h"
#import "FKLTopicVideoView.h"
#import "FKLTopicVoiceView.h"
#import "FKLTopicPictureView.h"
#import "UIImageView+FKLDownload.h"

@interface FKLTopicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *repostButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIView *topcmtView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtLabel;
/** 图片控件 */
@property (nonatomic, strong) FKLTopicPictureView *pictureView;
/** 声音控件 */
@property (nonatomic, strong) FKLTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, strong) FKLTopicVideoView *videoView;
@end

@implementation FKLTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopic:(FKLTopic *)topic
{
    _topic = topic;
    [self.profileImageView fkl_setCircleHeader:topic.profile_image];
    
    self.nameLabel.text = topic.name;
    self.passTimeLabel.text = topic.passtime;
    self.text_label.text = topic.text;
    
    [self setupButtonTitle:self.dingButton number:topic.ding placehoder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placehoder:@"踩"];
    [self setupButtonTitle:self.repostButton number:topic.repost placehoder:@"分享"];
    [self setupButtonTitle:self.commentButton number:topic.comment placehoder:@"评论"];
    
    // 最热评论
    if ( topic.top_cmt.count )
    {
        self.topcmtView.hidden = NO;
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if ( content.length == 0 )
        {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.topCmtLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    }
    else
    {
        self.topcmtView.hidden = YES;
    }
    
    // 中间的内容
    switch ( topic.type )
    {
        case FKLTopicTypePicture:
        {
            [self.pictureView setHidden:NO];
            [self.videoView setHidden:YES];
            [self.voiceView setHidden:YES];
            break;
        }
        case FKLTopicTypeVideo:
        {
            [self.videoView setHidden:NO];
            [self.pictureView setHidden:YES];
            [self.voiceView setHidden:YES];
            self.videoView.topic = topic;
            break;
        }
        case FKLTopicTypeVoice:
        {
            [self.voiceView setHidden:NO];
            [self.videoView setHidden:YES];
            [self.pictureView setHidden:YES];
            self.voiceView.topic = topic;
            break;
        }
        default:
        {
            [self.pictureView setHidden:YES];
            [self.videoView setHidden:YES];
            [self.voiceView setHidden:YES];
        }
    }
}
- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placehoder:(NSString *)placeholder
{
    if ( number >= 10000 )
    {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    }
    else if ( number > 0 )
    {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    }
    else
    {
        [button setTitle:@"顶" forState:UIControlStateNormal];
    }
}
- (void)setFrame:(CGRect)frame
{
    frame.size.height -= FKLMargin;
    [super setFrame:frame];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    // 中间的内容
    switch ( self.topic.type )
    {
        case FKLTopicTypePicture:
        {
            [self.pictureView setFrame:self.topic.middleFrame];
            [self.videoView setFrame:CGRectZero];
            [self.voiceView setFrame:CGRectZero];
            break;
        }
        case FKLTopicTypeVideo:
        {
            [self.pictureView setFrame:CGRectZero];
            [self.videoView setFrame:self.topic.middleFrame];
            [self.voiceView setFrame:CGRectZero];
            break;
        }
        case FKLTopicTypeVoice:
        {
            [self.pictureView setFrame:CGRectZero];
            [self.videoView setFrame:CGRectZero];
            [self.voiceView setFrame:self.topic.middleFrame];
            break;
        }
        default:
        {
            [self.pictureView setFrame:CGRectZero];
            [self.videoView setFrame:CGRectZero];
            [self.voiceView setFrame:CGRectZero];
        }
    }
}
#pragma mark - getter methods
- (FKLTopicPictureView *)pictureView
{
    if ( nil == _pictureView )
    {
        _pictureView = [FKLTopicPictureView fkl_viewFromXib];
        [self.contentView addSubview:_pictureView];
    }
    return _pictureView;
}
- (FKLTopicVoiceView *)voiceView
{
    if ( nil == _voiceView )
    {
        _voiceView = [FKLTopicVoiceView fkl_viewFromXib];
        [self.contentView addSubview:_voiceView];
    }
    return _voiceView;
}
- (FKLTopicVideoView *)videoView
{
    if ( nil == _videoView )
    {
        _videoView = [FKLTopicVideoView fkl_viewFromXib];
        [self.contentView addSubview:_videoView];
    }
    return _videoView;
}
@end
