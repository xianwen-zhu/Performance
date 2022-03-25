//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWCpuUtil : NSObject

/**
 *  获取cpu使用信息
 */
+ (CGFloat)cpuUsageForApp;

@end

NS_ASSUME_NONNULL_END
