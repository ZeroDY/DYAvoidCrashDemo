//
//  NSTimer+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/2/8.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <objc/runtime.h>
#import "DYAvoidCrashRecord.h"
#import "DYSwizzling.h"

@interface DYTimerProxy : NSObject

@property (nonatomic, weak) NSTimer *sourceTimer;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL aSelector;

@end

@implementation DYTimerProxy

- (void)trigger:(id)userinfo  {
    id strongTarget = self.target;
    if (strongTarget && ([strongTarget respondsToSelector:self.aSelector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:userinfo];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.sourceTimer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = @"an object dealloc not invalidate Timer.";
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":NSStringFromSelector(self.aSelector),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Timer];
    }
}

@end

@interface NSTimer (ShieldProperty)

@property (nonatomic, strong) DYTimerProxy *timerProxy;

@end

@implementation NSTimer (Shield)

- (void)setTimerProxy:(DYTimerProxy *)timerProxy {
    objc_setAssociatedObject(self, @selector(timerProxy), timerProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (DYTimerProxy *)timerProxy {
    return objc_getAssociatedObject(self, @selector(timerProxy));
}

@end

DYStaticHookMetaClass(NSTimer,
                      ProtectTimer,
                      NSTimer * ,
                      @selector(scheduledTimerWithTimeInterval:target:selector:userInfo:repeats:),
                      (NSTimeInterval)ti ,
                      (id)aTarget,
                      (SEL)aSelector,
                      (id)userInfo,
                      (BOOL)yesOrNo ) {
    if (yesOrNo) {
        NSTimer *timer =  nil ;
        @autoreleasepool {
            DYTimerProxy *proxy = [DYTimerProxy new];
            proxy.target = aTarget;
            proxy.aSelector = aSelector;
            timer.timerProxy = proxy;
            timer = DYHookOrgin(ti, proxy, @selector(trigger:), userInfo, yesOrNo);
            proxy.sourceTimer = timer;
        }
        return  timer;
    }
    return DYHookOrgin(ti, aTarget, aSelector, userInfo, yesOrNo);
}
DYStaticHookEnd
