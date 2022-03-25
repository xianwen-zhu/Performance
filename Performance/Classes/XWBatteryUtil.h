//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWBatteryUtil : NSObject

/**
 *  开始监控
 *
 *  @param block 电量变化后的回调
 */
- (void)startWithNotiBlock:(void(^)(double))block;

@end

NS_ASSUME_NONNULL_END
