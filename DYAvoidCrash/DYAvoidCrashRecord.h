//
//  DYAvoidCrashReport.h
//  ZDY
//
//  Created by ZDY on 2020/9/7.
//  Copyright © 2020 ZDY. All rights reserved.
//

#import "DYAvoidCrash.h"

NS_ASSUME_NONNULL_BEGIN

@interface DYAvoidCrashRecord : NSObject

/**
 注册汇报中心
 
 @param record 汇报中心
 */
+ (void)registerRecordHandler:(nullable id<DYAvoidCrashRecordProtocol>)record;

/**
 汇报Crash
 
 @param reason NSDictionary 原因
 */
+ (void)recordErrorWithReason:(nullable NSDictionary *)reason
                    errorType:(DYAvoidCrashType)type;

//+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols;

@end

NS_ASSUME_NONNULL_END
