//
//  NSMutableString+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2020/9/10.
//  Copyright © 2020 ZDY. All rights reserved.
//


#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"


/*
 NSMutableString->Methods On Protection:
 2、insertString:atIndex:
 3、deleteCharactersInRange:
 */


DYStaticHookPrivateClass(__NSCFString,
                         NSMutableString *,
                         ProtectCont,
                         id,
                         @selector(insertString:atIndex:),
                         (NSString *)str,
                         (NSUInteger)index) {
    if (!str) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = @"string insert nil.";
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(insertString:atIndex:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    if (index > self.length) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = [NSString stringWithFormat:@"index %@ out of length %@ of string.", @(index), @(self.length)];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(insertString:atIndex:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(str, index);
    
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSCFString,
                         NSMutableString *,
                         ProtectCont,
                         id,
                         @selector(deleteCharactersInRange:),
                         (NSRange)range) {
    NSUInteger index = range.location + range.length;
    if (index > self.length) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        
        NSString *reason = [NSString stringWithFormat:@"range (%@,%@) out of length %@ of string.", @(range.location), @(range.length), @(self.length)];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(deleteCharactersInRange:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(range);
    
}
DYStaticHookEnd
