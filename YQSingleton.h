//
//  YQSingleton.h
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YQDownLoadOperation.h"

@interface YQSingleton : NSObject
+ (instancetype)sharedManager;

/// 单例下载图片
- (void)downloadImageWithURLString:(NSString *)URLString finishedBlock:(void(^)(UIImage *image))finishedBlock;
/// 单例取消正在执行的下载操作
- (void)cancelOperationWithLastURLString:(NSString *)lastURLString;
@end
