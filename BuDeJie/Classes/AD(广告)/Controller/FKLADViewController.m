//
//  FKLADController.m
//  BuDeJie
//
//  Created by kun on 16/8/22.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLADViewController.h"

@interface FKLADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *LaunchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContainView;

@end

@implementation FKLADViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置启动图片
    [self setupLaunchImage];
    // 加载广告数据
    
}
#pragma mark - 设置启动图片
- (void)setupLaunchImage
{
    /*
     6P:LaunchImage-800-Portrait-736h@3x
     6:LaunchImage-800-667h@2x
     5:LaunchImage-568h@2x
     4s:LaunchImage@2x
     */
    NSString *imageName;
    if ( iPhone6p )
    {
        imageName = @"LaunchImage-800-Portrait-736h@3x";
    }
    else if ( iPhone6 )
    {
        imageName = @"LaunchImage-800-667h@2x";
    }
    else if ( iPhone5 )
    {
        imageName = @"LaunchImage-568h@2x";
    }
    else if( iPhone4 )
    {
        imageName = @"LaunchImage@2x";
    }
    self.LaunchImageView.image = [UIImage imageNamed:imageName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
