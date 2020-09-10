//
//  NSObject+Forward.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//
#import <objc/runtime.h>
#import <dlfcn.h>
#import "DYAvoidCrashStubObject.h"
#import "DYAvoidCrashRecord.h"
#import "DYSwizzling.h"

static bool startsWith(const char *pre, const char *str) {
    size_t lenpre = strlen(pre),
    lenstr = strlen(str);
    return lenstr < lenpre ? false : strncmp(pre, str, lenpre) == 0;
}


DYStaticHookClass(NSObject,
                  ProtectFW,
                  id,
                  @selector(forwardingTargetForSelector:),
                  (SEL)aSelector) {

    static dispatch_once_t onceToken;
    static char *app_bundle_path = NULL;

    dispatch_once(&onceToken, ^{
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        app_bundle_path = malloc(strlen(path) + 1);
        strcpy(app_bundle_path, path);
    });

    struct dl_info self_info = {0};
    dladdr((__bridge void *)[self class], &self_info);

    // 忽略系统类; 通常认为hook系统的类是非常有安全隐患的。这里过滤掉了系统类
    if (self_info.dli_fname == NULL || !startsWith(app_bundle_path, self_info.dli_fname)) {
        return DYHookOrgin(aSelector);
    }
    
    if ([self isKindOfClass:[NSNumber class]] && [NSString instancesRespondToSelector:aSelector]) {
        NSNumber *number = (NSNumber *)self;
        NSString *str = [number stringValue];
        return str;
    } else if ([self isKindOfClass:[NSString class]] && [NSNumber instancesRespondToSelector:aSelector]) {
        NSString *str = (NSString *)self;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *number = [formatter numberFromString:str];
        return number;
    }
    
    BOOL aBool = [self respondsToSelector:aSelector];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return DYHookOrgin(aSelector);
    } else {
        DYAvoidCrashStubObject *stub = [DYAvoidCrashStubObject shareInstance];
        [stub addFunc:aSelector];
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = @"method forword to SmartFunction Object default implement like send message to nil.";
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":NSStringFromSelector(aSelector),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_UnrecognizedSelector];
        
        return stub;
    }
}
DYStaticHookEnd

DYStaticHookMetaClass(NSObject,
                      ProtectFW,
                      id,
                      @selector(forwardingTargetForSelector:),
                      (SEL)aSelector) {
    
    BOOL aBool = [self respondsToSelector:aSelector];
    
    NSMethodSignature *signatrue = [self methodSignatureForSelector:aSelector];
    
    if (aBool || signatrue) {
        return DYHookOrgin(aSelector);
    } else {
        [DYAvoidCrashStubObject addClassFunc:aSelector];
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = @"method forword to SmartFunction Object default implement like send message to nil.";
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":NSStringFromSelector(aSelector),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_UnrecognizedSelector];
        
        return [DYAvoidCrashStubObject class];
    }
}
DYStaticHookEnd

