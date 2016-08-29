//
//  FKLTopic.m
//  BuDeJie
//
//  Created by kun on 16/8/26.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTopic.h"

@implementation FKLTopic
- (CGFloat)cellHeight
{
    if ( _cellHeight ) return _cellHeight;
    // 文字的Y值
    _cellHeight += 55;
    // 内容的高度
    CGSize textMaxSize = CGSizeMake(FKLScreenW - 2 * FKLMargin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + FKLMargin;
    // 中间的内容
    if ( FKLTopicTypeWord != self.type && FKLTopicTypeAll != self.type )
    {
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if ( FKLScreenH <= middleH )
        {
            middleH = 200;
            self.bigPicture = YES;
        }
        CGFloat middleY = _cellHeight;
        CGFloat middleX = FKLMargin;
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + FKLMargin;
    }
    // 最热评论
    if ( self.top_cmt.count )
    {
        // 标题
        _cellHeight += 20;
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if ( content.length == 0 )
        {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtStr = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtStr boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + FKLMargin;
    }
    // 工具条
    _cellHeight += 35 + FKLMargin;
    return _cellHeight;
}
@end
