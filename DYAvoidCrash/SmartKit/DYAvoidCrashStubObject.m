//
//  DYAvoidCrashStubObject.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYAvoidCrashStubObject.h"
#import <objc/runtime.h>

/**
 default Implement

 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

@implementation DYAvoidCrashStubObject

+ (DYAvoidCrashStubObject *)shareInstance {
    static DYAvoidCrashStubObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [DYAvoidCrashStubObject new];
        });
    }
    return singleton;
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([DYAvoidCrashStubObject class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([DYAvoidCrashStubObject class]));
    return __addMethod(metaClass, sel);
}

@end
