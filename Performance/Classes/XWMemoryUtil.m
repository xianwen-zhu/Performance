//
//  PERViewController.h
//  Performance
//
//  Created by xianwen-zhu on 03/25/2022.
//  Copyright (c) 2022 xianwen-zhu. All rights reserved.
//

#import "XWMemoryUtil.h"
#include <mach/mach.h>

@implementation XWMemoryUtil

//当前app内存使用量
+ (float)useMemoryForApp{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS)
    {
        float memoryUsageInByte = (float)vmInfo.phys_footprint;
        return (float)(memoryUsageInByte/1024/1024);
    }
    else
    {
        return -1.00;
    }
}

//设备总的内存
+ (NSInteger)totalMemoryForDevice{
    return (NSInteger)([NSProcessInfo processInfo].physicalMemory/1024/1024);
}

@end
