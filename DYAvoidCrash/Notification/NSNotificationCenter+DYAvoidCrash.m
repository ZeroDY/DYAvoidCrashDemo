//
//  NSNotificationCenter+DYAvoidCrash.m
//  ZDY
//
//  Created by ZDY on 2019/2/8.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYSwizzling.h"

@interface DYObserverRemover : NSObject

@end

@implementation DYObserverRemover {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = @[].mutableCopy;
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter*)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}

@end

// why autorelasePool
// an instance life dead
// *1 release property
// *2 remove AssociatedObject
// *3 destory self
// Once u want use assobciedObject's dealloc method do something ,
// must in a custome autorelease Pool let associate
// release immediately.
// AssociatedObject retain source target  strategy must be __unsafe_unretain. (weak will be nil )
void addCenterForObserver(NSNotificationCenter *center ,id obs) {
    DYObserverRemover *remover = nil;
    static char removerKey;
    
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, &removerKey);
        if (!remover) {
            remover = [[DYObserverRemover alloc] initWithObserver:obs];
            objc_setAssociatedObject(obs, &removerKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
}

DYStaticHookClass(NSNotificationCenter,
                  ProtectNoti,
                  void,
                  @selector(addObserver:selector:name:object:),
                  (id)obs,
                  (SEL)cmd,
                  (NSString*)name,
                  (id)obj) {
    DYHookOrgin(obs, cmd, name, obj);
    addCenterForObserver(self, obs);
}
DYStaticHookEnd
