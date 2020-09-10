//
//  DYSwizzling.h
//  ZDY
//
//  Created by ZDY on 2019/3/26.
//  Copyright © 2019年 ZDY All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "DYMetamacros.h"

#define DYForOCString(_) @#_

#define DYSEL2Str(_) NSStringFromSelector(_)

#define FOREACH_ARGS(MACRO, ...)  \
        metamacro_if_eq(1,metamacro_argcount(__VA_ARGS__))                                                      \
        ()                                                                                                      \
        (metamacro_foreach(MACRO , , metamacro_tail(__VA_ARGS__)))                                              \


#define CREATE_ARGS_DELETE_PAREN(VALUE) ,VALUE

#define CREATE_ARGS(INDEX,VALUE) CREATE_ARGS_DELETE_PAREN VALUE

#define __CREATE_ARGS_DELETE_PAREN(...) \
        [type appendFormat:@"%s",@encode(metamacro_head(__VA_ARGS__))];

#define CRATE_TYPE_CODING_DEL_VAR(TYPE) TYPE ,

#define CRATE_TYPE_CODING(INDEX,VALUE) \
        __CREATE_ARGS_DELETE_PAREN(CRATE_TYPE_CODING_DEL_VAR VALUE)

#define __DYHookType__void ,

#define __DYHookTypeIsVoidType(...)  \
        metamacro_if_eq(metamacro_argcount(__VA_ARGS__),2)

#define DYHookTypeIsVoidType(TYPE) \
        __DYHookTypeIsVoidType(__DYHookType__ ## TYPE)

// 调用原始函数 
#define DYHookOrgin(...)                                                                                        \
            __dy_hook_orgin_function                                                                            \
            ?__dy_hook_orgin_function(self,__dyHookSel,##__VA_ARGS__)                                           \
            :((typeof(__dy_hook_orgin_function))(class_getMethodImplementation(__dyHookSuperClass,__dyHookSel)))(self,__dyHookSel,##__VA_ARGS__)


// 生成真实调用函数
#define __DYHookClassBegin(theHookClass,                                                                        \
                           notWorkSubClass,                                                                     \
                           addMethod,                                                                           \
                           returnValue,                                                                         \
                           returnType,                                                                          \
                           theSEL,                                                                              \
                           theSelfTypeAndVar,                                                                   \
                           ...)                                                                                 \
                                                                                                                \
    static char associatedKey;                                                                                  \
    __unused Class __dyHookClass = avoid_hook_getClassFromObject(theHookClass);                                \
    __unused Class __dyHookSuperClass = class_getSuperclass(__dyHookClass);                                     \
    __unused SEL __dyHookSel  = theSEL;                                                                         \
    if (nil == __dyHookClass                                                                                    \
        || objc_getAssociatedObject(__dyHookClass, &associatedKey))                                             \
    {                                                                                                           \
        return NO;                                                                                              \
    }                                                                                                           \
    metamacro_if_eq(addMethod,1)                                                                                \
    (                                                                                                           \
        if (!class_respondsToSelector(__dyHookClass,__dyHookSel))                                               \
        {                                                                                                       \
            id _emptyBlock = ^returnType(id self                                                                \
                                         FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                            \
            {                                                                                                   \
                Method method = class_getInstanceMethod(__dyHookSuperClass,__dyHookSel);                        \
                if (method)                                                                                     \
                {                                                                                               \
                    __unused                                                                                    \
                    returnType(*superFunction)(theSelfTypeAndVar,                                               \
                                               SEL _cmd                                                         \
                                               FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                      \
                    = (void*)method_getImplementation(method);                                                  \
                    DYHookTypeIsVoidType(returnType)                                                            \
                    ()                                                                                          \
                    (return )                                                                                   \
                    superFunction(self,__dyHookSel,##__VA_ARGS__);                                              \
                }                                                                                               \
                else                                                                                            \
                {                                                                                               \
                    DYHookTypeIsVoidType(returnType)                                                            \
                    (return;)                                                                                   \
                    (return returnValue;)                                                                       \
                }                                                                                               \
            };                                                                                                  \
            NSMutableString *type = [[NSMutableString alloc] init];                                             \
            [type appendFormat:@"%s@:", @encode(returnType)];                                                   \
            FOREACH_ARGS(CRATE_TYPE_CODING,1,##__VA_ARGS__ )                                                    \
            class_addMethod(__dyHookClass,                                                                      \
                            theSEL,                                                                             \
                            (IMP)imp_implementationWithBlock(_emptyBlock),                                      \
                            type.UTF8String);                                                                   \
        }                                                                                                       \
    )                                                                                                           \
    ()                                                                                                          \
    if (!class_respondsToSelector(__dyHookClass,__dyHookSel))                                                   \
    {                                                                                                           \
        return NO;                                                                                              \
    }                                                                                                           \
    __block __unused                                                                                            \
    returnType(*__dy_hook_orgin_function)(theSelfTypeAndVar,                                                    \
                                          SEL _cmd                                                              \
                                          FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ ))                           \
                = NULL;                                                                                         \
    id newImpBlock =                                                                                            \
    ^returnType(theSelfTypeAndVar FOREACH_ARGS(CREATE_ARGS,1,##__VA_ARGS__ )) {                                 \
            metamacro_if_eq(notWorkSubClass,1)                                                                  \
            (if (!avoid_hook_check_block(object_getClass(self),__dyHookClass,&associatedKey))                  \
             {                                                                                                  \
              DYHookTypeIsVoidType(returnType)                                                                  \
              (DYHookOrgin(__VA_ARGS__ ); return;)                                                              \
              (return DYHookOrgin(__VA_ARGS__ );)                                                               \
            })                                                                                                  \
            ()                                                                                                  \


#define __dyHookClassEnd                                                                                        \
    };                                                                                                          \
    objc_setAssociatedObject(__dyHookClass,                                                                     \
                             &associatedKey,                                                                    \
                             [newImpBlock copy],                                                                \
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);                                                \
    __dy_hook_orgin_function = avoid_hook_imp_function(__dyHookClass,                                          \
                                                         __dyHookSel,                                           \
                                                         imp_implementationWithBlock(newImpBlock));             \
                                                                                                                \

// 拦截静态类 私有
#define __DYStaticHookClass(theCFunctionName,theHookClassType,selfType,GroupName,returnType,theSEL,... )        \
        static BOOL theCFunctionName ();                                                                        \
        static void* metamacro_concat(theCFunctionName, pointer) __attribute__ ((used, section ("__DATA,__sh" # GroupName))) = theCFunctionName;                                   \
        static BOOL theCFunctionName () {                                                                       \
        __DYHookClassBegin(theHookClassType,                                                                    \
                           0,                                                                                   \
                           0,                                                                                   \
                            ,                                                                                   \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            selfType self,                                                                      \
                            ##__VA_ARGS__)                                                                      \

// 拦截静态类
#define DYStaticHookPrivateClass(theHookClassType,publicType,GroupName,returnType,theSEL,... )                  \
        __DYStaticHookClass(metamacro_concat(__avoid_hook_auto_load_function_ , __COUNTER__),                  \
                            NSClassFromString(@#theHookClassType),                                              \
                            publicType,                                                                         \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

#define DYStaticHookClass(theHookClassType,GroupName,returnType,theSEL,... )                                    \
        __DYStaticHookClass(metamacro_concat(__avoid_hook_auto_load_function_ , __COUNTER__),                  \
                            [theHookClassType class],                                                           \
                            theHookClassType*,                                                                  \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \


#define DYStaticHookMetaClass(theHookClassType,GroupName,returnType,theSEL,... )                                \
        __DYStaticHookClass(metamacro_concat(__avoid_hook_auto_load_function_ , __COUNTER__),                  \
                            object_getClass([theHookClassType class]),                                          \
                            Class,                                                                              \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \


#define DYStaticHookPrivateMetaClass(theHookClassType,publicType,GroupName,returnType,theSEL,... )              \
        __DYStaticHookClass(metamacro_concat(__avoid_hook_auto_load_function_ , __COUNTER__),                  \
                            object_getClass(NSClassFromString(@#theHookClassType)),                             \
                            publicType,                                                                         \
                            GroupName,                                                                          \
                            returnType,                                                                         \
                            theSEL,                                                                             \
                            ## __VA_ARGS__ )                                                                    \

#define DYStaticHookEnd   __dyHookClassEnd        return YES;  }

#define DYStaticHookEnd_SaveOri(P) __dyHookClassEnd P = __dy_hook_orgin_function;  return YES;   }              \



#define NSSelectorFromWordsForEach(INDEX,VALUE)                                                                 \
            metamacro_if_eq(metamacro_is_even(INDEX),1)                                                         \
                                (@#VALUE)                                                                       \
                                (@"%@")

#define NSSelectorFromWordsForEach2(INDEX,VALUE)                                                                \
            metamacro_if_eq(metamacro_is_even(INDEX),1)                                                         \
                                ()                                                                              \
                                (,@#VALUE)

#define NSSelectorFromWords(...) \
        NSSelectorFromString( [NSString stringWithFormat:metamacro_foreach(NSSelectorFromWordsForEach,,__VA_ARGS__) \
        metamacro_foreach(NSSelectorFromWordsForEach2,,__VA_ARGS__) ])





// 私有 不要手动调用
void * avoid_hook_imp_function(Class clazz,
                                SEL   sel,
                                void  *newFunction);
BOOL avoid_hook_check_block(Class objectClass, Class hookClass,void* associatedKey);
Class avoid_hook_getClassFromObject(id object);


// 启动
void avoid_hook_load_group(NSString* groupName);
BOOL defaultSwizzlingOCMethod(Class self, SEL origSel_, SEL altSel_);
