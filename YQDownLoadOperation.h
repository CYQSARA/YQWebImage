//
//  YQDownLoadOperation.h
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+cache.h"


@interface YQDownLoadOperation : NSOperation
/// 快速实例化自定义的操作对象,同时指定图片的下载地址和下载完成之后的回调
+ (instancetype)downloadOperationWithURLString:(NSString *)URLString finishedBlock:(void(^)(UIImage *image))finishedBlock;

@end
