//
//  NSArray+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <objc/runtime.h>
#import "DYSwizzling.h"
#import "DYAvoidCrashRecord.h"


/**
 *  Can avoid crash method
 *
 *  1. NSArray的快速创建方式 NSArray *array = @[@"chenfanfang", @"AvoidCrash"];  //这种创建方式其实调用的是2中的方法
 *  2. +(instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt
 *  3. - (id)objectAtIndex:(NSUInteger)index
 *  4. - (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range
 */

//NSArray<NSString *> *arrayClasses = @[@"__NSSingleObjectArrayI",@"__NSArrayI",@"__NSArray0"];

/**
 hook @selector(objectAtIndex:)

 @param 
 @param NSArray
 @param ProtectCont
 @param id
 @param objectAtIndex:
 @return safe
 */


//=================================================================
//                         objectAtIndex:
//=================================================================
#pragma mark - objectAtIndex:

DYStaticHookClass(NSArray,
                  ProtectCont,
                  id,
                  @selector(objectAtIndex:),
                  (NSUInteger)index) {
    #include "NSArrayObjectAtIndex.h"
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSArrayI,
                         NSArray *,
                         ProtectCont,
                         id,
                         @selector(objectAtIndex:),
                         (NSUInteger)index) {
#include "NSArrayObjectAtIndex.h"
}
DYStaticHookEnd



DYStaticHookPrivateClass(__NSArray0,
                         NSArray *,
                         ProtectCont,
                         id,
                         @selector(objectAtIndex:),
                         (NSUInteger)index) {
#include "NSArrayObjectAtIndex.h"
}
DYStaticHookEnd


DYStaticHookPrivateClass(__NSSingleObjectArrayI,
                         NSArray *,
                         ProtectCont,
                         id,
                         @selector(objectAtIndex:),
                         (NSUInteger)index) {
    #include "NSArrayObjectAtIndex.h"
}
DYStaticHookEnd

//=================================================================
//                     objectAtIndexedSubscript:
//=================================================================
#pragma mark - objectAtIndexedSubscript:
DYStaticHookPrivateClass(__NSArrayI,
                         NSArray *,
                         ProtectCont,
                         id,
                         @selector(objectAtIndexedSubscript:),
                         (NSUInteger)index) {
    #include "NSArrayObjectAtIndex.h"
}
DYStaticHookEnd

//=================================================================
//                       objectsAtIndexes:
//=================================================================
#pragma mark - objectsAtIndexes:
DYStaticHookClass(NSArray,
                  ProtectCont,
                  id,
                  @selector(objectsAtIndexes:),
                  (NSIndexSet *)indexes) {
    if (indexes.lastIndex >= self.count) {
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *reason = [NSString stringWithFormat:@"index %@ out of count %@ of array.", @(indexes.lastIndex), @(self.count)];
        
        NSDictionary *errorInfo = @{
            @"target":[self class],
            @"method":DYSEL2Str(@selector(objectsAtIndexes:)),
            @"reason":reason,
            @"callStackSymbolsArr":callStackSymbolsArr,
        };
        
        [DYAvoidCrashRecord recordErrorWithReason:errorInfo errorType:DYAvoidCrashType_Container];
        return nil;
    }
    
    return DYHookOrgin(indexes);
    
}
DYStaticHookEnd


//NSArray<NSString *> *arrayClasses = @[@"__NSSingleObjectArrayI",@"__NSArrayI",@"__NSArray0"];

/**
 hook @selector(arrayWithObjects:count:),
 
 @param
 @param NSArray
 @param ProtectCont
 @param id
 @param objectAtIndex:
 @return safe
 */
//=================================================================
//                        instance array
//=================================================================
#pragma mark - instance array

DYStaticHookPrivateMetaClass(__NSSingleObjectArrayI,
                             NSArray *,
                             ProtectCont,
                             NSArray *,
                             @selector(arrayWithObjects:count:),
                             (const id *)objects,
                             (NSUInteger)cnt) {
    #include "NSArrayWithObjects.h"
}
DYStaticHookEnd

DYStaticHookPrivateMetaClass(__NSArrayI,
                             NSArray *,
                             ProtectCont,
                             NSArray *,
                             @selector(arrayWithObjects:count:),
                             (const id *)objects,
                             (NSUInteger)cnt) {
    #include "NSArrayWithObjects.h"
}
DYStaticHookEnd

DYStaticHookPrivateMetaClass(__NSArray0,
                             NSArray *,
                             ProtectCont,
                             NSArray *,
                             @selector(arrayWithObjects:count:),
                             (const id *)objects,
                             (NSUInteger)cnt) {
    #include "NSArrayWithObjects.h"
}
DYStaticHookEnd

DYStaticHookPrivateClass(__NSPlaceholderArray,
                         NSArray *,
                         ProtectCont,
                         NSArray *,
                         @selector(initWithObjects:count:),
                         (const id *)objects,
                         (NSUInteger)cnt) {
    #include "NSArrayWithObjects.h"
}
DYStaticHookEnd
