//
//  FKLWordViewController.m
//  BuDeJie
//
//  Created by kun on 16/8/25.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLWordViewController.h"

@interface FKLWordViewController ()

@end

@implementation FKLWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加内边距
    self.tableView.contentInset = UIEdgeInsetsMake(FKLNaviMaxY + FKLTitleViewH, 0, FKLTabBarH, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if ( nil == cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *text = [NSString stringWithFormat:@"%@ - %ld", NSStringFromClass([self class]), indexPath.row];
    cell.textLabel.text = text;
    return cell;
}
@end