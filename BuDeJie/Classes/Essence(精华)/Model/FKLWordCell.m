//
//  FKLWordCell.m
//  BuDeJie
//
//  Created by kun on 16/8/26.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLWordCell.h"

@implementation FKLWordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

@end
