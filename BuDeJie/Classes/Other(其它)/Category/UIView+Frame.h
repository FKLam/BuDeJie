//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, assign) CGFloat fkl_width;
@property (nonatomic, assign) CGFloat fkl_height;
@property (nonatomic, assign) CGPoint fkl_center;
@property (nonatomic, assign) CGFloat fkl_x;
@property (nonatomic, assign) CGFloat fkl_y;
@property (nonatomic, assign) CGFloat fkl_centerX;
@property (nonatomic, assign) CGFloat fkl_centerY;

/** 根据类名创建由 xib 生成的 View */
+ (instancetype)fkl_viewFromXib;
@end
