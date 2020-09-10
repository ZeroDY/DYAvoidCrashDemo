//
//  NSObject+DanglingPointer.h
//  ZDY
//
//  Created by ZDY on 2019/3/25.
//  Copyright © 2019年 ZDY All rights reserved.
//


#import <objc/runtime.h>
#import "NSObject+DanglingPointer.h"
#import "DYDanglingPointStub.h"
#import "DYDanglingPonterService.h"
#import <list>

static NSInteger const threshold = 100;

static std::list<id> undellocedList;

@implementation NSObject (DanglingPointer)

- (void)dy_danglingPointer_dealloc {
    Class selfClazz = object_getClass(self);
    
    BOOL needProtect = NO;
    for (NSString *className in [DYDanglingPonterService getInstance].classArr) {
        Class clazz = objc_getClass([className UTF8String]);
        if (clazz == selfClazz) {
            needProtect = YES;
            break;
        }
    }
    
    if (needProtect) {
        objc_destructInstance(self);
        object_setClass(self, [DYDanglingPointStub class]);
        
        undellocedList.size();
        if (undellocedList.size() >= threshold) {
            id object = undellocedList.front();
            undellocedList.pop_front();
            free(object);
        }
        undellocedList.push_back(self);
    } else {
        [self dy_danglingPointer_dealloc];
    }
}

@end
