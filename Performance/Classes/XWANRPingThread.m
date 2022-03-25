//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import "XWANRPingThread.h"
#import "DoraemonBacktraceLogger.h"

@interface XWANRPingThread()

/// 应用是否在活跃状态
@property (nonatomic, assign) BOOL isApplicationInActive;
/// 控制ping主线程的信号量
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
/// 卡顿阈值
@property (nonatomic, assign) double threshold;
/// 主线程是否阻塞
@property (nonatomic, assign, getter = isMainThreadBlock) BOOL mainThreadBlock;
/// 卡顿堆栈信息
@property (nonatomic, copy) NSString *backtraceInfo;
/// 每一次ping开始的时间,上报延迟时间统计
@property (nonatomic, assign) double startTimeValue;
@property (nonatomic, copy) void(^block)(NSDictionary *);

@end

@implementation XWANRPingThread

- (instancetype)initWithThreshold:(double)threshold notiBlock:(void(^)(NSDictionary *))block {
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(0);
        self.threshold = threshold;
        _isApplicationInActive = YES;
        self.block = block;
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidBecomeActive) name: UIApplicationDidBecomeActiveNotification object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object: nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)main {
    /// 上报卡顿信息
    __weak typeof(self) weakSelf = self;
    void (^ verifyReport)(void) = ^() {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        double responseTimeValue = [[NSDate date] timeIntervalSince1970];
        double duration = (responseTimeValue - strongSelf.startTimeValue)*1000;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.block(@{
                @"title": [strongSelf dateFormatNow].length > 0 ? [strongSelf dateFormatNow] : @"",
                @"duration": [NSString stringWithFormat:@"%.0f",duration],//单位ms
                @"content": strongSelf.backtraceInfo
                       });
        });
    };
    
    while (!self.cancelled) {
        /// app 在前台时监控卡顿
        if (_isApplicationInActive) {
            self.mainThreadBlock = YES;/// 主线程是否阻塞
            self.backtraceInfo = @"";/// 卡顿堆栈信息
            self.startTimeValue = [[NSDate date] timeIntervalSince1970];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mainThreadBlock = NO;
                dispatch_semaphore_signal(self.semaphore);
            });
            /// threshold为卡顿阀值
            [NSThread sleepForTimeInterval:self.threshold];
            if (self.isMainThreadBlock) {
                /// 出现卡顿，获取卡顿堆栈信息
                self.backtraceInfo = [DoraemonBacktraceLogger doraemon_backtraceOfMainThread];
            }
            dispatch_semaphore_wait(self.semaphore, dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC));
            if (self.backtraceInfo.length > 0) {
                /// 有卡顿，汇报卡顿信息
                verifyReport();
            }
        } else {
            [NSThread sleepForTimeInterval:self.threshold];
        }
    }
}

#pragma mark - Notific ation
- (void)applicationDidBecomeActive {
    _isApplicationInActive = YES;
}

- (void)applicationDidEnterBackground {
    _isApplicationInActive = NO;
}

- (NSString *)dateFormatNow{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

@end
