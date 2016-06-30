//
//  YQSingleton.m
//  self-仿SDWebImage练习
//
//  Created by Cuiyongqin on 16/4/22.
//  Copyright © 2016年 Cuiyongqin. All rights reserved.
//

#import "YQSingleton.h"


@interface YQSingleton ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *OPCache;
@property (nonatomic, strong) NSMutableDictionary *imageCache;

@end

@implementation YQSingleton

- (NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)OPCache
{
    if (_OPCache == nil) {
        _OPCache = [[NSMutableDictionary alloc] init];
    }
    return _OPCache;
}

- (NSMutableDictionary *)imageCache
{
    if (_imageCache == nil) {
        _imageCache = [[NSMutableDictionary alloc] init];
    }
    return _imageCache;
}

+ (instancetype)sharedManager
{
    static YQSingleton *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YQSingleton alloc] init];
    });
    return instance;
}

/*
 1.Block : 代码不简洁,但是逻辑简单.
 2.因为这是第三方框架的架构设计,所以相对复杂.但是,开发中使用的Block没有这么复杂.
 3.类方法自定义DownlaodOperation是Block在类与类之间传值的典范.
 4.Block传值用多了就会自然熟悉.类似代理.
 */

// 负责下载
- (void)downloadImageWithURLString:(NSString *)URLString finishedBlock:(void (^)(UIImage *))finishedBlock
{
    // 判断有没有缓存
    if ([self checkCache:URLString]) {
        // 把缓存的图片回调给控制器
        // finishedBlock : 是分类传进来的
        if (finishedBlock != nil) {
            finishedBlock([self.imageCache objectForKey:URLString]);
        }
        
        return;
    }
    
    // 判断如果当前图片对应的下载操作,在操作缓存池已经有了,就不在建立新的下载操作
    if ([self.OPCache objectForKey:URLString] != nil) {
        return;
    }
    
    // 是DownloadOperation把图片下载完成之后要回调的代码块
    void(^finishedBlock_m)() = ^(UIImage *image) {
        // 回调分类传入的更新UI的代码块
        if (finishedBlock != nil) {
            finishedBlock(image);
        }
        
        // 保存图片
        [self.imageCache setObject:image forKey:URLString];
        
        // 图片下载完成之后,把对应的下载操作移除
        [self.OPCache removeObjectForKey:URLString];
    };
    
    // 拿到随机的图片地址,去下载
    YQDownLoadOperation *op = [YQDownLoadOperation downloadOperationWithURLString:URLString finishedBlock:finishedBlock_m];
    
    // 把自定义的下载操作添加到操作缓存池
    [self.OPCache setObject:op forKey:URLString];
    // 把自定义的下载操作对象添加到队列
    [self.queue addOperation:op];
}

#pragma mark - 判断有没有缓存
- (BOOL)checkCache:(NSString *)URLString
{
    // 判断有没有内存缓存
    if ([self.imageCache objectForKey:URLString] != nil) {
        NSLog(@"从内存中加载...");
        return YES;
    }
    
    // 判断有没有沙盒缓存
    UIImage *cache_image = [UIImage imageWithContentsOfFile:[URLString cachePath]];
    if (cache_image != nil) {
        NSLog(@"从沙盒中加载...");
        
        // 把沙盒的图片在内存中再保存一份
        [self.imageCache setObject:cache_image forKey:URLString];
        
        return YES;
    }
    
    return NO;
}

// 负责取消正在执行的下载操作
- (void)cancelOperationWithLastURLString:(NSString *)lastURLString
{
    // 当通过lastURLString取出来的操作对象为空,就没有必要调用cancel
    YQDownLoadOperation *lastOP = [self.OPCache objectForKey:lastURLString];
    if (lastOP != nil) {
        [lastOP cancel];
        
        // 已经被取消的操作需要从操作缓存池移除
        [self.OPCache removeObjectForKey:lastURLString];
    }
}

@end




















