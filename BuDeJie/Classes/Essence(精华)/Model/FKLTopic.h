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
/** 帖子类型 10为图片，29为段子，31为音频，41为视频 */
@property (nonatomic, assign) FKLTopicType type;
@end
