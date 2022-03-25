//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import "XWBatteryUtil.h"
#import <objc/runtime.h>

@implementation XWBatteryUtil

- (instancetype)init {
    if (self = [super init]) {
        [UIDevice currentDevice].batteryMonitoringEnabled =YES;
    }
    return self;
}

- (void)startWithNotiBlock:(void (^)(double))block {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", [UIDevice currentDevice].batteryLevel] forKey:@"battery"];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIDeviceBatteryLevelDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification*notification) {
        if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging || [UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
            //充电中
        }
        else {
            //不在充电
            block([[[NSUserDefaults standardUserDefaults] objectForKey:@"battery"] floatValue] - [UIDevice currentDevice].batteryLevel);
        }
    }];
}

@end
