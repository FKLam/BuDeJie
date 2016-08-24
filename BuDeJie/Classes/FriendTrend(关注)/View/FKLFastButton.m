//
//  FKLFastButton.m
//  BuDeJie
//
//  Created by kun on 16/8/24.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLFastButton.h"

@implementation FKLFastButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 设置图片位置
    self.imageView.fkl_y = 0;
    self.imageView.fkl_centerX = self.fkl_width * 0.5;
    // 设置标题位置
    self.titleLabel.fkl_y = self.fkl_height - self.titleLabel.fkl_height;// 计算文子宽度，设置label的宽度
    [self.titleLabel sizeToFit];
    self.titleLabel.fkl_centerX = self.fkl_width * 0.5;
}

@end
