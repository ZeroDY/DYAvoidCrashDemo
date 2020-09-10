//
//  NSObject+DanglingPointer.h
//  ZDY
//
//  Created by ZDY on 2019/3/25.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DanglingPointer)

- (void)dy_danglingPointer_dealloc;

@end
