//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import "XWPerformance.h"
#import "XWPerformanceDetailView.h"
#import "XWFpsUtil.h"
#import "XWBatteryUtil.h"
#import "XWCpuUtil.h"
#import "XWMemoryUtil.h"
#import "XWANRUtil.h"
#import "Aspects.h"

///性能检测单例
static XWPerformance *sharedInstance = nil;

@interface XWPerformance()

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, strong) XWPerformanceDetailView *detailView;
@property (nonatomic, strong) XWANRUtil *anr;
@property (nonatomic, strong) XWFpsUtil *fps;
@property (nonatomic, strong) XWBatteryUtil *battery;
@property (nonatomic, strong) NSMutableArray *anrList;

@end

@implementation XWPerformance

+ (instancetype)start {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sharedInstance initialPerformanceUI];
            [sharedInstance initialPerformanceTool];
        });
    });
    return sharedInstance;
}

#pragma mark - 初始化性能检测详情视图
- (void)initialPerformanceUI {
    UIWindow *keyWindow = [[UIApplication sharedApplication] delegate].window;
    [keyWindow addSubview:self.detailView];
    self.detailView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.detailView.topAnchor constraintEqualToAnchor:keyWindow.topAnchor].active = YES;
    [self.detailView.leftAnchor constraintEqualToAnchor:keyWindow.leftAnchor].active = YES;
    [self.detailView.bottomAnchor constraintEqualToAnchor:keyWindow.bottomAnchor].active = YES;
    [self.detailView.rightAnchor constraintEqualToAnchor:keyWindow.rightAnchor].active = YES;
}

#pragma mark - 初始化性能检测工具
- (void)initialPerformanceTool {
    __weak typeof(self)weakSelf = self;
    self.fps = [[XWFpsUtil alloc] init];
    [self.fps startWithNotiBlock:^(NSInteger fps) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (keyWindow.subviews.lastObject != weakSelf.detailView) {
            if (![keyWindow.subviews containsObject:weakSelf.detailView]) {
                [weakSelf.detailView removeFromSuperview];
                [keyWindow addSubview:weakSelf.detailView];
                weakSelf.detailView.translatesAutoresizingMaskIntoConstraints = NO;
                [weakSelf.detailView.topAnchor constraintEqualToAnchor:keyWindow.topAnchor].active = YES;
                [weakSelf.detailView.leftAnchor constraintEqualToAnchor:keyWindow.leftAnchor].active = YES;
                [weakSelf.detailView.bottomAnchor constraintEqualToAnchor:keyWindow.bottomAnchor].active = YES;
                [weakSelf.detailView.rightAnchor constraintEqualToAnchor:keyWindow.rightAnchor].active = YES;
            }
            [keyWindow bringSubviewToFront:weakSelf.detailView];
        }
        weakSelf.detailView.fps = fps;
        weakSelf.detailView.CpuLbl.text = [NSString stringWithFormat:@"CPU:%0.2f%@", [XWCpuUtil cpuUsageForApp]*100, @"%"];
//        weakSelf.detailView.MemoryLbl.text = [NSString stringWithFormat:@"RAM:%0.2f", (float)[EPTMemoryUtil useMemoryForApp]/[EPTMemoryUtil totalMemoryForDevice]*100];
        weakSelf.detailView.MemoryLbl.text = [NSString stringWithFormat:@"RAM:%0.2fMB", [XWMemoryUtil useMemoryForApp]];
    }];
    /// 电池电量
    self.battery = [[XWBatteryUtil alloc] init];
    self.detailView.BatteryLbl.text = [NSString stringWithFormat:@"耗电:%0.2f%@", 0.0000*100, @"%"];
    [self.battery startWithNotiBlock:^(double battery) {
        weakSelf.detailView.BatteryLbl.text = [NSString stringWithFormat:@"耗电:%0.2f%@", battery*100, @"%"];
    }];
    /// 启动时间
    self.detailView.StartTimeLbl.text = [NSString stringWithFormat:@"冷启动:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"launchTime"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"launchTime"] : @""];
    /// 记录控制器viewDidLoad的时间
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        weakSelf.startTime = [[NSDate date] timeIntervalSince1970];
    } error:NULL];
    /// 记录控制器viewDidAppear的时间
    [UIViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
        weakSelf.endTime = [[NSDate date] timeIntervalSince1970];
        if (weakSelf.startTime != 0) {
            float initialTime = weakSelf.endTime - weakSelf.startTime;
            weakSelf.detailView.pageInitialLbl.text = [NSString stringWithFormat:@"%@：%0.2fms", NSStringFromClass([[weakSelf findCurrentShowingViewController] class]), initialTime*1000];
        }
        weakSelf.endTime = 0;
        weakSelf.startTime = 0;
    } error:NULL];
    /// 卡顿
    self.anr = [[XWANRUtil alloc] init];
    [self.anr startWithThreshold:0.2 notiBlock:^(NSDictionary * _Nonnull info) {
        NSString *currentCrl = NSStringFromClass([[weakSelf findCurrentShowingViewController] class]);
        if (![weakSelf.anrList containsObject:currentCrl]) {
            [weakSelf.anrList addObject:currentCrl];
        }
        if (weakSelf.anrList.count > 5) {
            [weakSelf.anrList removeObjectAtIndex:0];
        }
        weakSelf.detailView.anrList = [weakSelf.anrList copy];
    }];
}

#pragma mark - 获得当前活动窗口的控制器
- (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

//注意考虑几种特殊情况：①A present B, B present C，参数vc为A时候的情况
- (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc
{
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    return currentShowingVC;
}

#pragma mark - getter
- (UIView *)detailView {
    if (!_detailView) {
        _detailView = [[XWPerformanceDetailView alloc] init];
    }
    return _detailView;;
}

- (NSMutableArray *)anrList {
    if (!_anrList) {
        _anrList = [NSMutableArray array];
    }
    return _anrList;
}

@end
