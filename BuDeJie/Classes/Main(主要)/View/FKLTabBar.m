//
//  FKLTabBar.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTabBar.h"

@interface FKLTabBar ()
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) UIControl *previousSelectedControl;
@end

@implementation FKLTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.items.count;
    CGFloat btnW = 1.0 * self.bounds.size.width / (count + 1);
    CGFloat btnH = self.bounds.size.height;
    CGFloat x = 0;
    NSInteger index = 0;
    // 遍历子控件，调整布局
    for ( UIControl *tabBarButton in self.subviews )
    {
        if ( [tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")] )
        {
            if ( 0 == index && nil == self.previousSelectedControl )
                self.previousSelectedControl = tabBarButton;
            if ( index == 2 )
            {
                index++;
            }
            x = index * btnW;
            tabBarButton.frame = CGRectMake(x, 0, btnW, btnH);
            index++;
            [tabBarButton addTarget:self action:@selector(clickTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // 调整发布按钮位置
    self.publishBtn.center = CGPointMake(self.fkl_width * 0.5, self.fkl_height * 0.5 );
}
#pragma mark - 监听tabBarButton的点击
- (void)clickTabBarButton:(UIControl *)sender
{
    if ( sender == self.previousSelectedControl )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:FKLTabBarButtonDidRepeatClickNotification object:nil];
        return;
    }
    self.previousSelectedControl = sender;
}
#pragma mark - getter methods
- (UIButton *)publishBtn
{
    if ( nil == _publishBtn )
    {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [_publishBtn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [_publishBtn sizeToFit];
        [self addSubview:_publishBtn];
    }
    return _publishBtn;
}
@end
