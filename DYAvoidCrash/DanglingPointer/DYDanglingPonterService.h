//
//  DYDanglingPonterService.h
//  ZDY
//
//  Created by ZDY on 2019/3/25.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYDanglingPonterService : NSObject

@property (nonatomic, copy) NSArray<NSString *> *classArr;

+ (instancetype)getInstance;

@end
