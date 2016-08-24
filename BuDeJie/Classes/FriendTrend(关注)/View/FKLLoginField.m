//
//  FKLLoginField.m
//  BuDeJie
//
//  Created by kun on 16/8/24.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLLoginField.h"
#import "UITextField+Placeholder.h"
@implementation FKLLoginField
/*
 1，文本框光标变成白色
 2，文本框开始编辑的时候，占位文字颜色变成白色
 */
- (void)awakeFromNib
{
    // 设置光标的颜色为白色
    self.tintColor = [UIColor whiteColor];
    // 监听文本编辑：1，代理 2，通知 3，target
    // 原则：不要自己成为自己的代理
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    // 想法：快速设置占位文字颜色
    self.placeholderColor = [UIColor lightGrayColor];
}

#pragma mark - 文本框编辑
- (void)textBegin
{
    // 设置占位文字颜色变成白色
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    self.placeholderColor = [UIColor whiteColor];
}
- (void)textEnd
{
    // 设置占位文字颜色变成白色
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    self.placeholderColor = [UIColor lightGrayColor];
}
@end
