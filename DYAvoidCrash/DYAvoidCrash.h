//
//  DYAvoidCrash.h
//  ZDY
//
//  Created by ZDY on 2020/9/7.
//  Copyright © 2020 ZDY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, DYAvoidCrashType) {
    DYAvoidCrashType_UnrecognizedSelector = 1 << 1,
    DYAvoidCrashType_Container = 1 << 2,
    DYAvoidCrashType_NSNull = 1 << 3,
    DYAvoidCrashType_KVO = 1 << 4,
    DYAvoidCrashType_Notification = 1 << 5,
    DYAvoidCrashType_Timer = 1 << 6,
    DYAvoidCrashType_DanglingPointer = 1 << 7,
    DYAvoidCrashType_ExceptDanglingPointer = (DYAvoidCrashType_UnrecognizedSelector
                                             | DYAvoidCrashType_Container
                                             | DYAvoidCrashType_NSNull
                                             | DYAvoidCrashType_KVO
                                             | DYAvoidCrashType_Notification
                                             | DYAvoidCrashType_Timer)
};

@protocol DYAvoidCrashRecordProtocol <NSObject>

- (void)recordWithErrorInfo:(NSDictionary *)errorInfo;

@end


@interface DYAvoidCrash : NSObject



/**
 开启 AvoidCrash
 默认不包含 DYAvoidCrashType_DanglingPointer 类型
 */
+ (void)registerAvoidCrash;

/**
 开启 AvoidCrash
 
 @param type DYAvoidCrashType
 */
+ (void)registerAvoidCrashWithType:(DYAvoidCrashType)type;

/**
 开启 DYAvoidCrashTypeDanglingPointer 需要传入存储类名的array，不支持系统框架类。

 @param type type
 @param classNames 野指针类列表
 */
+ (void)registerAvoidCrashWithType:(DYAvoidCrashType)type withClassNames:(nonnull NSArray<NSString *> *)classNames;

/**
 注册汇报中心
 
 @param record 汇报中心
 */
+ (void)registerRecordHandler:(id<DYAvoidCrashRecordProtocol>)record;


@end

NS_ASSUME_NONNULL_END
