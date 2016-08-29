//
//  FKLTopic.h
//  BuDeJie
//
//  Created by kun on 16/8/26.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FKLTopicType) {
    /** 全部 */
    FKLTopicTypeAll = 1,
    /** 图片 */
    FKLTopicTypePicture = 10,
    /** 段子 */
    FKLTopicTypeWord = 29,
    /** 声音 */
    FKLTopicTypeVoice = 31,
    /** 视频 */
    FKLTopicTypeVideo = 41
};

@interface FKLTopic : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容*/
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 声音图片宽度 */
@property (nonatomic, assign) NSInteger width;
/** 声音图片高度 */
@property (nonatomic, assign) NSInteger height;
/** 帖子类型 10为图片，29为段子，31为音频，41为视频 */
@property (nonatomic, assign) FKLTopicType type;
/** 当前模型对应cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 最热评论 */
@property (nonatomic, strong) NSArray * top_cmt;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect middleFrame;
/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;
/** 音频时长 秒 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 秒 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频／视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 是否为动图 */
@property (nonatomic, assign) BOOL is_gif;
/** 是否为长图 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@end
