//
//  NSString+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2020/9/9.
//  Copyright © 2020 ZDY. All rights reserved.
//

#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"


/*
 NSString->Methods On Protection:
 1、characterAtIndex：
 2、substringFromIndex:
 3、substringToIndex:
 4、substringWithRange:
 */

DYStaticHookPrivateClass(__NSCFConstantString,
                         NSString *,
                         ProtectCont,
                         unichar,
                         @selector(characterAtIndex:),
                         (NSUInteger)index) {
    if (index >= self.length) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"index %@ out of length %@ of string.", @(index), @(self.length)];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(characterAtIndex:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(index);
    
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSCFConstantString,
                         NSString *,
                         ProtectCont,
                         id,
                         @selector(substringFromIndex:),
                         (NSUInteger)index) {
    if (index >= self.length) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"index %@ out of length %@ of string.", @(index), @(self.length)];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(substringFromIndex:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(index);
    
}
DYStaticHookEnd

DYStaticHookPrivateClass(__NSCFConstantString,
                         NSString *,
                         ProtectCont,
                         NSString *,
                         @selector(substringToIndex:),
                         (NSUInteger)index) {
    if (index >= self.length) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"index %@ out of length %@ of string.", @(index), @(self.length)];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(substringToIndex:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(index);
    
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSCFConstantString,
                         NSString *,
                         ProtectCont,
                         id,
                         @selector(substringWithRange:),
                         (NSRange)range) {
    NSUInteger index = range.location + range.length;
    if (index > self.length) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *place = [DYAvoidCrashRecord getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];
        NSString *reason = [NSString stringWithFormat:@"range (%@,%@) out of length %@ of string.", @(range.location), @(range.length), @(self.length)];
        
        NSDictionary *errorInfo = @{
            @"place":place,
            @"target":[self class],
            @"method":DYSEL2Str(@selector(substringWithRange:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(range);
    
}
DYStaticHookEnd
