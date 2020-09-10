//
//  DYAvoidCrashStubObject.h
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYAvoidCrashStubObject : NSObject

- (instancetype)init __unavailable;

+ (DYAvoidCrashStubObject *)shareInstance;

- (BOOL)addFunc:(SEL)sel;

+ (BOOL)addClassFunc:(SEL)sel;

@end
