//
//  FKLLoginRegisterViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLLoginRegisterViewController.h"
#import "FKLLoginRegisterView.h"
#import "FKLFastLoginView.h"

@interface FKLLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) FKLLoginRegisterView *loginView;
@property (nonatomic, strong) FKLLoginRegisterView *registerView;
@property (nonatomic, strong) FKLFastLoginView *fastLoginView;
@end

@implementation FKLLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     屏幕适配：
     1，一个view从xib加载，需不需要再重新固定尺寸 一定要再重新设置frame
     2，在viewDidLoad中布局subView是否合适   在开发中一般在view DID Layout Su 把 Vi 额外布局子控件
     */
    // 创建登录view
    // 添加到中间的view上
    [self.middleView addSubview:self.loginView];
    [self.middleView addSubview:self.registerView];
    
    [self.bottomView addSubview:self.fastLoginView];
}
- (void)viewDidLayoutSubviews
{
    // 一定要调用super
    [super viewDidLayoutSubviews];
    self.loginView.frame = CGRectMake(0, 0, self.view.fkl_width, self.middleView.fkl_height);
    self.registerView.frame = CGRectMake(self.view.fkl_width, 0, self.view.fkl_width, self.middleView.fkl_height);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if ( sender.isSelected )
    {
        self.leadingCons.constant = -self.middleView.fkl_width * 0.5;
    }
    else
    {
        self.leadingCons.constant = 0;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
#pragma mark - getter methods
- (FKLLoginRegisterView *)loginView
{
    if ( nil == _loginView )
    {
        _loginView = [FKLLoginRegisterView loginView];
    }
    return _loginView;
}
- (FKLLoginRegisterView *)registerView
{
    if ( nil == _registerView )
    {
        _registerView = [FKLLoginRegisterView registerView];
    }
    return _registerView;
}
- (FKLFastLoginView *)fastLoginView
{
    if ( nil == _fastLoginView )
    {
        _fastLoginView = [FKLFastLoginView fastLoginView];
    }
    return _fastLoginView;
}
@end
