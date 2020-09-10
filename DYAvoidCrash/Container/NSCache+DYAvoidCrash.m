//
//  NSCache+DYAvoidCrash.m
//  Shield
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"


DYStaticHookClass(NSCache,
                  ProtectCont,
                  void,
                  @selector(setObject:forKey:),
                  (id)obj,
                  (id)key) {
    if (obj && key) {
        DYHookOrgin(obj,key);
    } else {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *reason = [NSString stringWithFormat:@"key or value appear nil- key is %@, object is %@.", key, obj];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(setObject:forKey:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_UnrecognizedSelector];
    }
}
DYStaticHookEnd


DYStaticHookClass(NSCache,
                  ProtectCont,
                  void,
                  @selector(setObject:forKey:cost:),
                  (id)obj,
                  (id)key,
                  (NSUInteger)g) {
    if (obj && key) {
        DYHookOrgin(obj,key,g);
    } else {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *reason = [NSString stringWithFormat:@"key or value appear nil- key is %@, object is %@.", key, obj];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(setObject:forKey:cost:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        
    }
}
DYStaticHookEnd

