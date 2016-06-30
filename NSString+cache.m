//
//  UIView+cache.m
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import "NSString+cache.h"

@implementation NSString(cache)
- (NSString *)cachePath {

    // 获取Caches文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 获取网络图片的名字
    NSString *name = [self lastPathComponent];
    // 路径拼接文件名字
    NSString *filePath = [path stringByAppendingPathComponent:name];
    
    return filePath;
}
@end
