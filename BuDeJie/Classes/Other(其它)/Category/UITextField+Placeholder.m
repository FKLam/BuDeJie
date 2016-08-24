//
//  UITextField+Placeholder.m
//  BuDeJie
//
//  Created by kun on 16/8/24.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)
@dynamic placeholderColor;

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = placeholderColor;
}
- (UIColor *)placeholderColor
{
    return nil;
}
@end
