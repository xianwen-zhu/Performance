//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWANRPingThread : NSThread

/**
 *  初始化Ping主线程的线程类
 *
 *  @param threshold 主线程卡顿阈值
 *  @param block 卡顿产生后的回调
 */
- (instancetype)initWithThreshold:(double)threshold notiBlock:(void(^)(NSDictionary *))block;

@end

NS_ASSUME_NONNULL_END
