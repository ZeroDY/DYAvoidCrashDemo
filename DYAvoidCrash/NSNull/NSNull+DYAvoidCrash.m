//
//  NSNull+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYSwizzling.h"

DYStaticHookClass(NSNull,
                  ProtectNull,
                  id,
                  @selector(forwardingTargetForSelector:),
                  (SEL) aSelector) {
    
    static NSArray *sTmpOutput = nil;
    if (sTmpOutput == nil) {
        sTmpOutput = @[@"", @0, @[], @{}];
    }
    
    for (id tmpObj in sTmpOutput) {
        if ([tmpObj respondsToSelector:aSelector]) {
            return tmpObj;
        }
    }
    return DYHookOrgin(aSelector);
}
DYStaticHookEnd

