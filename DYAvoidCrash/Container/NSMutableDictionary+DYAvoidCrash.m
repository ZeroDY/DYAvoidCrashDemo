//
//  NSMutableDictionary+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"

DYStaticHookPrivateClass(__NSDictionaryM,
                         NSMutableDictionary *,
                         ProtectCont,
                         void,
                         @selector(setObject:forKey:),
                         (id)anObject,
                         (id<NSCopying>)aKey ) {
    if (anObject && aKey) {
        DYHookOrgin(anObject,aKey);
    } else {
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"key or value appear nil- key is %@, obj is %@", aKey, anObject];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(setObject:forKey:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        
    }
    
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSDictionaryM,
                         NSMutableDictionary *,
                         ProtectCont,
                         void,
                         @selector(setObject:forKeyedSubscript:),
                         (id)anObject,
                         (id<NSCopying>)aKey ) {
    if (anObject && aKey) {
        DYHookOrgin(anObject,aKey);
    } else {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"key or value appear nil- key is %@, object is %@", aKey, anObject];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(setObject:forKeyedSubscript:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
    }
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSDictionaryM,
                         NSMutableDictionary *,
                         ProtectCont,
                         void,
                         @selector(removeObjectForKey:),
                         (id<NSCopying>)aKey ) {
    if (aKey) {
        DYHookOrgin(aKey);
    } else {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"key appear nil- key is %@.", aKey];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(removeObjectForKey:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
    }
    
}
DYStaticHookEnd
