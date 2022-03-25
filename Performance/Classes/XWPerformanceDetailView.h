//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWPerformanceDetailView : UIView

@property (nonatomic, strong) UILabel *FpsLbl;
@property (nonatomic, strong) UILabel *CpuLbl;
@property (nonatomic, strong) UILabel *MemoryLbl;
@property (nonatomic, strong) UILabel *StartTimeLbl;
@property (nonatomic, strong) UILabel *BatteryLbl;
@property (nonatomic, strong) UILabel *pageInitialLbl;
@property (nonatomic, copy) NSArray *anrList;
@property (nonatomic, assign) NSInteger fps;

@end

NS_ASSUME_NONNULL_END
