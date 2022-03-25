//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//
#import "XWANRUtil.h"
#import "XWANRPingThread.h"

@interface XWANRUtil()

/// 用于Ping主线程的线程实例
@property (nonatomic, strong) XWANRPingThread *pingThread;

@end

@implementation XWANRUtil

- (void)startWithThreshold:(double)threshold notiBlock:(void(^)(NSDictionary *))block {
    self.pingThread = [[XWANRPingThread alloc] initWithThreshold:threshold notiBlock:block];
    [self.pingThread start];
}

- (void)end {
    if (self.pingThread != nil) {
        [self.pingThread cancel];
        self.pingThread = nil;
    }
}

- (void)dealloc
{
    if (self.pingThread != nil) {
        [self.pingThread cancel];
        self.pingThread = nil;
    }
}

@end
