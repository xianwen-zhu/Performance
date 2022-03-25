//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWANRUtil : NSObject

/**
 *  开始监控
 *
 *  @param threshold 卡顿阈值
 *  @param block 卡顿产生后的回调
 */
- (void)startWithThreshold:(double)threshold notiBlock:(void(^)(NSDictionary *))block;

/**
 *  停止监控
 */
- (void)end;

@end

NS_ASSUME_NONNULL_END
