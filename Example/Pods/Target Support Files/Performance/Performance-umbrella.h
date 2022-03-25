#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PERAppDelegate.h"
#import "Aspects.h"
#import "DoraemonBacktraceLogger.h"
#import "XWANRPingThread.h"
#import "XWANRUtil.h"
#import "XWBatteryUtil.h"
#import "XWCpuUtil.h"
#import "XWFpsUtil.h"
#import "XWMemoryUtil.h"
#import "XWPerformance.h"
#import "XWPerformanceDetailView.h"
#import "XWStartTimeUtil.h"

FOUNDATION_EXPORT double PerformanceVersionNumber;
FOUNDATION_EXPORT const unsigned char PerformanceVersionString[];

