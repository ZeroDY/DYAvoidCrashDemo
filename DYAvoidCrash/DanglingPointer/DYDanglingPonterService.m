//
//  DYDanglingPonterService.m
//  ZDY
//
//  Created by ZDY on 2019/3/25.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import "DYDanglingPonterService.h"
#import <objc/runtime.h>

@implementation DYDanglingPonterService

+ (instancetype)getInstance {
    static DYDanglingPonterService *service = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[DYDanglingPonterService alloc] init];
    });
    return service;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _classArr = @[];
    }
    return self;
}

@end
