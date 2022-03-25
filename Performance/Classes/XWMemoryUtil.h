//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWMemoryUtil : NSObject

/**
 *  当前app内存使用量
 */
+ (float)useMemoryForApp;

/**
 *  设备总的内存
 */
+ (NSInteger)totalMemoryForDevice;

@end

NS_ASSUME_NONNULL_END
