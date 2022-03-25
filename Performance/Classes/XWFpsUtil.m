//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import "XWFpsUtil.h"

@interface XWFpsUtil()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) BOOL isStart;
@property (nonatomic, copy) void(^block)(NSInteger);

@end

@implementation XWFpsUtil

- (instancetype)init{
    self = [super init];
    if (self) {
        _isStart = NO;
        _count = 0;
        _lastTime = 0;
    }
    return self;
}

- (void)startWithNotiBlock:(void(^)(NSInteger))block {
    if (_link) {
        _link.paused = NO;
    }else{
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(trigger:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    self.block = block;
}

- (void)end {
    if (_link) {
        _link.paused = YES;
        [_link invalidate];
        _link = nil;
        _lastTime = 0;
        _count = 0;
    }
}

- (void)trigger:(CADisplayLink *)link {
    if (_lastTime == 0) {
        /// 设置每一个循环的初始时间
        _lastTime = link.timestamp;
        return;
    }
    /// 计算刷新次数
    _count++;
    /// 计算刷新时间差
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    /// 重置每一个循环的初始时间
    _lastTime = link.timestamp;
    /// 刷新时间大于等于1秒，开始计算fps = 刷新次数/刷新时间差，比如60hz = 刷新60次/1秒
    CGFloat fps = _count / delta;
    /// 刷新次数清零
    _count = 0;
    /// fps取整
    NSInteger intFps = (NSInteger)(fps+0.5);
    /// 传递fps
    self.block(intFps);
}

@end
