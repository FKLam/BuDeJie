//
//  FKLLoginRegisterViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLLoginRegisterViewController.h"
#import "FKLLoginRegisterView.h"

@interface FKLLoginRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

@implementation FKLLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建登录view
    FKLLoginRegisterView *loginView = [FKLLoginRegisterView loginView];
    // 添加到中间的view上
    [self.middleView addSubview:loginView];
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
}

@end
