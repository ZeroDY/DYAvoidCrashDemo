//
//  NSMutableArray+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"

DYStaticHookPrivateClass(__NSArrayM,
                         NSMutableArray *,
                         ProtectCont,
                         id,
                         @selector(objectAtIndexedSubscript:),
                         (NSUInteger)index) {
    if (index >= self.count) {
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = [NSString stringWithFormat:@"index %@ out of count %@ of marray.", @(index), @(self.count)];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(objectAtIndexedSubscript:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(index);
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSArrayM,
                         NSMutableArray *,
                         ProtectCont,
                         void,
                         @selector(addObject:),
                         (id)anObject) {
    if (anObject) {
        DYHookOrgin(anObject);
    }
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSArrayM,
                         NSMutableArray *,
                         ProtectCont,
                         void,
                         @selector(insertObject:atIndex:),
                         (id)anObject,
                         (NSUInteger)index) {
    if (anObject) {
        DYHookOrgin(anObject, index);
    }
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSArrayM,
                         NSMutableArray *,
                         ProtectCont,
                         void,
                         @selector(removeObjectAtIndex:),
                         (NSUInteger)index) {
    if (index >= self.count) {
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *reason = [NSString stringWithFormat:@"index %@ out of count %@ of marray.", @(index), @(self.count)];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(removeObjectAtIndex:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
    } else {
        DYHookOrgin(index);
    }
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSArrayM,
                         NSMutableArray *,
                         ProtectCont,
                         void,
                         @selector(setObject:atIndexedSubscript:),
                         (id) obj,
                         (NSUInteger)index) {
    if (obj) {
        if (index > self.count) {
            
            NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
            
            NSString *reason = [NSString stringWithFormat:@"index %@ out of count %@ of marray.", @(index), @(self.count)];
            
            NSDictionary *errorInfo = @{
                @"target":[self class],
                @"method":DYSEL2Str(@selector(setObject:atIndexedSubscript:)),
                @"reason":reason,
                @"callStackSymbolsArr":callStackSymbolsArr,
            };
            
            [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        } else {
            DYHookOrgin(obj, index);
        }
    } else {
        
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = [NSString stringWithFormat:@"object appear nil object is %@.", obj];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(setObject:atIndexedSubscript:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
    }
}
DYStaticHookEnd

