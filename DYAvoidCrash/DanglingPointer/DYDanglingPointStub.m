//
//  DYDanglingPointStub.m
//  ZDY
//
//  Created by ZDY on 2019/3/25.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYDanglingPointStub.h"
#import <objc/runtime.h>
#import "DYAvoidCrashStubObject.h"
#import "DYAvoidCrashRecord.h"

@implementation DYDanglingPointStub

- (instancetype)init {
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    DYAvoidCrashStubObject *stub = [DYAvoidCrashStubObject shareInstance];
    [stub addFunc:aSelector];

    return [[DYAvoidCrashStubObject class] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
    NSString *reason = @"Dangling Pointer .";
    
    NSDictionary *errorInfo = @{
        @"place":place,
        @"target":[self class],
        @"method":NSStringFromSelector(_cmd),
        @"reason":reason,
        @"callStackSymbolsArr":callStackSymbolsArr,
    };
    
    [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_DanglingPointer];
    
    [anInvocation invokeWithTarget:[DYAvoidCrashStubObject shareInstance]];
}

@end

