//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//
#import "XWStartTimeUtil.h"
#import <objc/runtime.h>

static CFAbsoluteTime startTime;

@implementation XWStartTimeUtil

+ (void)load {
    /// 获取默认AppPerformance配置，代理和第一个控制器
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MobileBase" ofType:@"bundle"];
    NSMutableDictionary *performanceDict = [NSDictionary dictionaryWithContentsOfFile:bundlePath].mutableCopy;
    Class class = NSClassFromString(performanceDict[@"AppDelegate"] ? performanceDict[@"AppDelegate"] : @"MBAppDelegate");
    Method originMethod = class_getInstanceMethod(class, @selector(application:didFinishLaunchingWithOptions:));
    Method newMethod = class_getInstanceMethod([self class], @selector(eptStartUtil_application:didFinishLaunchingWithOptions:));
    class_addMethod(class, method_getName(newMethod), method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    Method swizzledMethod = class_getInstanceMethod(class, @selector(eptStartUtil_application:didFinishLaunchingWithOptions:));
    method_exchangeImplementations(originMethod, swizzledMethod);
    
    Class crlClass = NSClassFromString(performanceDict[@"FirstController"] ? performanceDict[@"FirstController"] : @"MBTabBarController");
    Method originMethod1 = class_getInstanceMethod(crlClass, @selector(viewDidAppear:));
    Method newMethod1 = class_getInstanceMethod([self class], @selector(eptStartUtil_viewDidAppear:));
    class_addMethod(crlClass, method_getName(newMethod1), method_getImplementation(newMethod1), method_getTypeEncoding(newMethod1));
    Method swizzledMethod1 = class_getInstanceMethod(crlClass, @selector(eptStartUtil_viewDidAppear:));
    method_exchangeImplementations(originMethod1, swizzledMethod1);
}

- (BOOL)eptStartUtil_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    startTime = CFAbsoluteTimeGetCurrent();
    BOOL didLaunch = [self eptStartUtil_application:application didFinishLaunchingWithOptions:launchOptions];
    CFAbsoluteTime launchTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSString *launchTimeStr = [NSString stringWithFormat:@"%0.2fms", launchTime*1000];
#ifdef DEBUG
    NSLog(@"main之后到didFinishLaunchingWithOptions完成的启动时间 %@ms", launchTimeStr);
#endif
    return didLaunch;
}

- (void)eptStartUtil_viewDidAppear:(BOOL)animated {
    [self eptStartUtil_viewDidAppear:animated];
    CFAbsoluteTime launchTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSString *launchTimeStr = [NSString stringWithFormat:@"%0.2fms", launchTime*1000];
#ifdef DEBUG
    NSLog(@"main之后到第一个界面显示的启动时间 %@", launchTimeStr);
#endif
    [[NSUserDefaults standardUserDefaults] setObject:launchTimeStr forKey:@"launchTime"];
}

@end
