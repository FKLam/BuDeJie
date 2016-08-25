//
//  UITextField+Placeholder.m
//  BuDeJie
//
//  Created by kun on 16/8/24.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UITextField+Placeholder.h"
#import <objc/message.h>

@implementation UITextField (Placeholder)
@dynamic placeholderColor;

static char * const _placeholderColor = "placeholderColor";

+ (void)load
{
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setFklPlaceholderMethod = class_getInstanceMethod(self, @selector(setFkl_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setFklPlaceholderMethod);
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 给成员变量赋值 runtime给系统的类添加成员属性
    objc_setAssociatedObject(self, _placeholderColor, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, _placeholderColor);
}
/*
 设置占位文字
 设置占位文字颜色
 */
- (void)setFkl_Placeholder:(NSString *)placeholder
{
    [self setFkl_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}
@end
