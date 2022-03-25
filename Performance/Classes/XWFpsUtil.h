//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWFpsUtil : NSObject

/**
 *  开始监控
 *
 *  @param block 回调返回fps的值
 */
- (void)startWithNotiBlock:(void(^)(NSInteger))block;

/**
 *  结束监控
 */
- (void)end;

@end

NS_ASSUME_NONNULL_END
