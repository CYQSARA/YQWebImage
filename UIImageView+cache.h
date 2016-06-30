//
//  UIImageView+cache.h
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (cache)
@property(nonatomic,copy)NSString *lastURL;
- (void)sd_setImageWithURLString:(NSString *)URLString;

@end
