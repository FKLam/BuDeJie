//
//  FKLSquareCell.m
//  BuDeJie
//
//  Created by kun on 16/8/24.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLSquareCell.h"
#import <UIImageView+WebCache.h>

@interface FKLSquareCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FKLSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSquareItem:(FKLSquareItem *)squareItem
{
    _squareItem = squareItem;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:_squareItem.icon]];
    [self.nameLabel setText:_squareItem.name];
}
@end
