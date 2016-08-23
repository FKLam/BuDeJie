//
//  FKLADItem.h
//  BuDeJie
//
//  Created by kun on 16/8/23.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKLADItem : NSObject
/** 广告地址 */
@property (nonatomic, strong) NSString *w_picurl;
/** 点击广告跳转的界面 */
@property (nonatomic, strong) NSString *ori_curl;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@end
