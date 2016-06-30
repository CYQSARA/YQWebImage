//
//  UIImageView+cache.m
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import "UIImageView+cache.h"
#import <objc/runtime.h>
#import "YQSingleton.h"

@implementation UIImageView (cache)
- (void)setLastURLString:(NSString *)lastURLString
{
    /*
     参数1 : 关联的对象
     参数2 : 关联的KEY,通过key存value
     参数3 : 关联的value
     参数4 : value保存的策略
     */
    
    objc_setAssociatedObject(self, "key", lastURLString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)lastURLString
{
    /*
     参数1 : 关联的对象
     参数2 : 关联的KEY,通过key取value
     */
    return objc_getAssociatedObject(self, "key");
}

- (void)sd_setImageWithURLString:(NSString *)URLString
{
    // 判断本次图片的下载地址和上一次是不是一样的,如果不是一样的,就取消上一次的正在下载的操作.反之,什么都不做,继续下载
    if (![URLString isEqualToString:self.lastURLString]) {
        // 单例接管取消正在执行的下载操作
        [[YQSingleton sharedManager] cancelOperationWithLastURLString:self.lastURLString];
    }
    // 一定要在判断了之后,给lastURLString赋值
    self.lastURLString = URLString;
    
    // 图片下载完成之后,更新UI的代码块
    void(^finishedBlock)() = ^(UIImage *image) {
        self.image = image;
        NSLog(@"==image %@",image);
    };
    // 单例接管下载操作
    [[YQSingleton sharedManager] downloadImageWithURLString:URLString finishedBlock:finishedBlock];
}


@end












