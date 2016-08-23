//
//  FKLLoginRegisterView.m
//  BuDeJie
//
//  Created by kun on 16/8/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLLoginRegisterView.h"
@interface FKLLoginRegisterView()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;

@end
@implementation FKLLoginRegisterView

+ (instancetype)loginView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
+ (instancetype)registerView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib
{
    UIImage *image = self.loginRegisterButton.currentBackgroundImage;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 让按钮背景图片不要被拉伸
    [self.loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
}
@end
