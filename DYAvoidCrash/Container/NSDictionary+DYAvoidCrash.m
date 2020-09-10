//
//  NSDictionary+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"

DYStaticHookMetaClass(NSDictionary,
                      ProtectCont,
                      NSDictionary *,
                      @selector(dictionaryWithObjects:forKeys:count:),
                      (const id *)objects,
                      (const id<NSCopying> *)keys,
                      (NSUInteger)cnt) {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
            NSString *reason = @"NSDictionary constructor appear nil";
            NSDictionary *errorInfo = @{
                @"target":[self class],
                @"method":DYSEL2Str(@selector(dictionaryWithObjects:forKeys:count:)),
                @"reason":reason,
                @"callStackSymbolsArr":callStackSymbolsArr,
            };
            
            [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
            
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }
    
    return DYHookOrgin(newObjects, newkeys,index);
}
DYStaticHookEnd

