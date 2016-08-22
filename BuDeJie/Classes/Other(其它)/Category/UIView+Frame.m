//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
- (void)setFkl_height:(CGFloat)fkl_height
{
    CGRect rect = self.frame;
    rect.size.height = fkl_height;
    self.frame = rect;
}
- (CGFloat)fkl_height
{
    return self.frame.size.height;
}
- (void)setFkl_width:(CGFloat)fkl_width
{
    CGRect rect = self.frame;
    rect.size.width = fkl_width;
    self.frame = rect;
}
- (CGFloat)fkl_width
{
    return self.frame.size.width;
}
- (void)setFkl_x:(CGFloat)fkl_x
{
    CGRect rect = self.frame;
    rect.origin.x = fkl_x;
    self.frame = rect;
}
- (CGFloat)fkl_x
{
    return self.frame.origin.x;
}
- (void)setFkl_y:(CGFloat)fkl_y
{
    CGRect rect = self.frame;
    rect.origin.y = fkl_y;
    self.frame = rect;
}
- (CGFloat)fkl_y
{
    return self.frame.origin.y;
}
- (void)setFkl_center:(CGPoint)fkl_center
{
    self.center = fkl_center;
}
- (CGPoint)fkl_center
{
    return self.center;
}
@end
