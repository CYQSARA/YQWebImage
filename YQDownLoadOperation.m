//
//  YQDownLoadOperation.m
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import "YQDownLoadOperation.h"

@interface YQDownLoadOperation ()
/// 接受图片的地址
@property (nonatomic, copy) NSString *URLString;
/// 接受外界传入的代码块
@property (nonatomic, copy) void(^finishedBlock)(UIImage *image);
@end
@implementation YQDownLoadOperation

+ (instancetype)downloadOperationWithURLString:(NSString *)URLString finishedBlock:(void (^)(UIImage *))finishedBlock
{
    // 创建操作对象
    YQDownLoadOperation *op = [[YQDownLoadOperation alloc] init];
    
    // 保存外界传入的图片地址
    op.URLString = URLString;
    // 保存外界传入的回调
    op.finishedBlock = finishedBlock;
    
    // 返回操作对象
    return op;
}

/// 重写main方法,拦截操作执行的过程.相当于教室的门
- (void)main
{
    NSLog(@"传入 %@",self.URLString);
    
    // 模拟网络延迟 : 放大代码执行的效果
    [NSThread sleepForTimeInterval:1.0];
    
    // 一般在耗时操作的后面,判断当前操作是否被取消
    // 有的时候,可以在main方法的多个地方都做判断
    if (self.cancelled) {
        NSLog(@"取消 %@",self.URLString);
        return;
    }
    
    // 实现图片的下载
    NSURL *URL = [NSURL URLWithString:self.URLString];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *image = [UIImage imageWithData:data];
    
    // 图片为空就不存
    if (image != nil) {
        [data writeToFile:[self.URLString cachePath] atomically:YES];
    }
    
    // 断言 : 保证某一个条件一定满足,如果不满足就崩溃,并且可以自定义崩溃的原因.
    // 提示: 只在开发调试时有效,方便我们多人开发.
    NSAssert(self.finishedBlock != nil, @"图片下载完成的回调不能为空");
    
    // 图片下载完成,调用VC传进来的Block (回调),Block在调用之前一定要做为空的判断.
    // 实现主线程的回调
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"完成 %@",self.URLString);
        
        // 方便测试,回调图片地址,此时不会崩溃,因为只是做了打印操作,没有赋值
        self.finishedBlock(image);
    }];
}

@end

















