//
//  DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2020/9/7.
//  Copyright © 2020 ZDY. All rights reserved.
//

#import <objc/runtime.h>
#import "DYAvoidCrash.h"
#import "NSObject+DanglingPointer.h"
#import "DYDanglingPonterService.h"
#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"

@implementation DYAvoidCrash

+ (void)registerAvoidCrash {
    [self registerAvoidCrashWithType:DYAvoidCrashType_ExceptDanglingPointer];
}

+ (void)registerAvoidCrashWithType:(DYAvoidCrashType)type {
    if (type & DYAvoidCrashType_UnrecognizedSelector) {
        [self registerUnrecognizedSelector];
    }
    if (type & DYAvoidCrashType_Container) {
        [self registerContainer];
    }
    if (type & DYAvoidCrashType_NSNull) {
        [self registerNSNull];
    }
    if (type & DYAvoidCrashType_KVO) {
        [self registerKVO];
    }
    if (type & DYAvoidCrashType_Notification) {
        [self registerNotification];
    }
    if (type & DYAvoidCrashType_Timer) {
        [self registerTimer];
    }
}

+ (void)registerAvoidCrashWithType:(DYAvoidCrashType)type
                    withClassNames:(NSArray<NSString *> *)classNames {
    if ((type & DYAvoidCrashType_DanglingPointer) && [classNames count]) {
        [self registerDanglingPointer:classNames];
    }
    [self registerAvoidCrashWithType:type];
}



+ (void)registerNSNull {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avoid_hook_load_group(DYForOCString(ProtectNull));
    });
}

+ (void)registerContainer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avoid_hook_load_group(DYForOCString(ProtectCont));
    });
}

+ (void)registerUnrecognizedSelector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avoid_hook_load_group(DYForOCString(ProtectFW));
    });
}

+ (void)registerKVO {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avoid_hook_load_group(DYForOCString(ProtectKVO));
    });
}

+ (void)registerNotification {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL ABOVE_IOS8  = (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO);
        if (!ABOVE_IOS8) {
            avoid_hook_load_group(DYForOCString(ProtectNoti));
        }
    });
}

+ (void)registerTimer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        avoid_hook_load_group(DYForOCString(ProtectTimer));
    });
}


+ (void)registerDanglingPointer:(NSArray *)arr {
    NSMutableArray *avaibleList = arr.mutableCopy;
    for (NSString *className in arr) {
        NSBundle *classBundle = [NSBundle bundleForClass:NSClassFromString(className)];
        if (classBundle != [NSBundle mainBundle]) {
            [avaibleList removeObject:className];
        }
    }
    [DYDanglingPonterService getInstance].classArr = avaibleList;
    defaultSwizzlingOCMethod([NSObject class],
                             NSSelectorFromString(@"dealloc"),
                             @selector(dy_danglingPointer_dealloc));
}


+ (void)registerRecordHandler:(nonnull id<DYAvoidCrashRecordProtocol>)record {
    [DYAvoidCrashRecord registerRecordHandler:record];
}


@end

