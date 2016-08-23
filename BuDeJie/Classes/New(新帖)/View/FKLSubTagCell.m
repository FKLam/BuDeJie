//
//  FKLSubTagCell.m
//  BuDeJie
//
//  Created by kun on 16/8/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLSubTagCell.h"
#import <UIImageView+WebCache.h>

/*
 头像变成圆角 1，设置头像圆角 2，裁剪图片
 处理数字
 */

@interface FKLSubTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
@implementation FKLSubTagCell

// 从xib加载就会调用一次
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 设置头像圆角
    _iconView.layer.cornerRadius = 30.0;
    _iconView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(FKLSubTagItem *)item
{
    _item = item;
    
    // 设置内容
    _nameLabel.text = item.theme_name;
    // 判断有没有 > 10000
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅", item.sub_number];
    NSInteger num = item.sub_number.integerValue;
    if ( num > 10000 )
    {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%0.1f万人订阅", numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    _numLabel.text = numStr;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:item.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end
