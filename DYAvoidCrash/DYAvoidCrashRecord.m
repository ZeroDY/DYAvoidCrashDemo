//
//  DYAvoidCrashReport.m
//  ZDY
//
//  Created by ZDY on 2020/9/7.
//  Copyright © 2020 ZDY. All rights reserved.
//

#import "DYAvoidCrashRecord.h"

@implementation DYAvoidCrashRecord

static id<DYAvoidCrashRecordProtocol> __record;

+ (void)registerRecordHandler:(id<DYAvoidCrashRecordProtocol>)record {
    __record = record;
}

+ (void)recordErrorWithReason:(nullable NSDictionary *)reason
                    errorType:(DYAvoidCrashType)type {
    NSMutableDictionary *errorInfo = reason.mutableCopy;
    NSInteger errorCode = -type;
    errorInfo[@"errorCode"] = @(errorCode);
    [__record recordWithErrorInfo:errorInfo];
    
}

//
///**
// *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
// *
// *  @param callStackSymbols 堆栈主要崩溃信息
// *
// *  @return 堆栈主要崩溃精简化的信息
// */
//
//+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
//    
//    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
//    __block NSString *mainCallStackSymbolMsg = nil;
//    
//    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
//    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
//    
//    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr
//                                                                           options:NSRegularExpressionCaseInsensitive
//                                                                             error:nil];
//    for (int index = 1; index < callStackSymbols.count; index++) {
//        NSString *callStackSymbol = callStackSymbols[index];
//        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
//            if (result) {
//                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
//                
//                //get className
//                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
//                className = [className componentsSeparatedByString:@"["].lastObject;
//                
//                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
//                
//                //filter category and system class
//                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
//                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
//                }
//                *stop = YES;
//            }
//        }];
//        
//        if (mainCallStackSymbolMsg.length) {
//            break;
//        }
//    }
//    
//    return mainCallStackSymbolMsg;
//}
//


@end
