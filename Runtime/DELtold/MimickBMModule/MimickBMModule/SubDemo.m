//
//  SubDemo.m
//  MimickBMModule
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "SubDemo.h"
#import <BMModuleKit/BMModuleKit.h>
#import "Person.h"

@implementation SubDemo

- (void)demo {
    // [self demo1]; // 输入字符转字符串
    // [self demo2]; // 字符串转Class
    // [self demo3]; // 字符串转SEL
    // [self demo4]; // module_router
    // [self demo5]; // IMP使用
    // [self demo6]; // @module(XXX)
    [self demo7]; // object_getClass
}

- (void)sayHello {
    NSLog(@"hello");
}

- (void)demo1 {
    // 作用时字符串化
    #define module_stringify(...) @#__VA_ARGS__
    NSLog(@"%@", module_stringify(Hello)); // Hello
}

- (void)demo2 {
    // 相当于#define AAA(xxx) NSClassFromString(@"xxx")
    // 即把string转为class
    #define module_class_from_string(...) (0).boolValue ? nil : ^Class {\
        return NSClassFromString(@#__VA_ARGS__);\
    }()
    
    Class cls = @module_class_from_string(SubDemo);
    [[[cls alloc] init] sayHello];
}

- (void)demo3 {
    #define module_selector_from_string(...) (0).boolValue ? nil : ^SEL {\
        return NSSelectorFromString(@#__VA_ARGS__);\
    }()
    
    SubDemo *demo = [[SubDemo alloc] init];
    [demo performSelector:@module_selector_from_string(sayHello)];
}

- (id)demo4 {
    // 这一堆代码相当于：[BMModuleRouter sharedRouter]
    Class routerClass = BMModuleRouter.class; // module_class_from_string(BMModuleRouter);
    if (routerClass) {
        SEL sel = NSSelectorFromString(@"sharedRouter");
        [routerClass instanceMethodForSelector:sel];
        if (sel && [routerClass respondsToSelector:sel]) {
            IMP imp = [routerClass methodForSelector:sel];
            return ((id (*)(id, SEL))imp)(routerClass, sel);
        }
    }
    return nil;
}

- (void)demo5 {
    SEL selector = @selector(personWithName:age:);
    IMP imp = [Person methodForSelector:selector];
    Person *p = ((id (*)(id, SEL, NSString *, NSInteger))imp)(Person.class, selector, @"daliu", 30);
    NSLog(@"%@", p.name);
}

- (void)demo6 {
/**
 比如： @module(BMBindCarSDKModule);
 这相当于：
 @interface BMModule_BMBindCarSDKModule : NSObject
 @end
 
 @implementation BMModule_BMBindCarSDKModule
 
 + (void)load {
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        [super load];
        Class targetClass = @module_class_from_string(T);
        if (targetClass) {
            [[BMModuleRouter sharedRouter] addModule:targetClass];
        }
    }
 }
 @end
 */
    /**
#define module(T, ...) interface BMModule_##T : NSObject @end @implementation BMModule_##T + (void)load {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        [super load];\
        Class targetClass = @module_class_from_string(T);\
        if (targetClass) {\
            id router = @module_router();\
            if (router) {\
                SEL sel = @module_selector_from_string(addModule:);\
                if (sel && [router respondsToSelector:sel]) {\
                    IMP imp = [router methodForSelector:sel];\
                    ((void (*)(id, SEL, id, ...))imp)\
                    (router, sel, targetClass, ## __VA_ARGS__, nil);\
                }\
            }\
        }\
    });\
} @end
    */
}

- (void)demo7 {
    Person *p = [[Person alloc] init];
    NSLog(@"%@  address: %p",
          object_getClass(p), // Person
          object_getClass(p)); // 0x103dbb2d0
    NSLog(@"%@  address: %p  address2: %p",
          object_getClass(Person.class), // Person
          object_getClass(Person.class), // 0x103dbb2a8
          Person.class); // 0x103dbb2d0
    // class_copyMethodList(Class  _Nullable __unsafe_unretained cls, unsigned int * _Nullable outCount)
}

/**
使用：@module_call(BMLoginQRCodeViewModule.getLoginVehicleAuth:, vc);
 // 参数URL: BMLoginQRCodeViewModule.getLoginVehicleAuth:
 // 可变参: vc
 
#define module_call(URL, ...) (0).boolValue ? nil : ^void * {\
    id router = @module_router();
    if (router) {
        SEL sel = @module_selector_from_string(route:);
        if (sel && [router respondsToSelector:sel]) {
            IMP imp = [router methodForSelector:sel];
            return ((void * (*)(id, SEL, id, ...))imp)(router, sel, @#URL, ## __VA_ARGS__, nil);
        }
    } return nil;
}()
 
 相当于：
 BMModuleRouter *router = [BMModuleRouter sharedRouter];
 if (router) {
    SEL sel = @selector(route:);
    if (sel && [router respondsToSelector:sel]) {
        IMP imp = [router methodForSelector:sel];
        return ((void * (*)(id, SEL, id, ...))imp)(router, sel, @#URL, ## __VA_ARGS__, nil);
    }
 }
 
 @module(BMBindCarSDKModule);
 如果：@module_call(BMLoginQRCodeViewModule.getLoginVehicleAuth:, vc);
 即：[[BMModuleRouter sharedRouter] route:@"BMLoginQRCodeViewModule.getLoginVehicleAuth:", vc, nil];
 
 根据 `BMLoginQRCodeViewModule.getLoginVehicleAuth:` 创建invocation对象，然后调用：[invocation invoke: vc]
 */

@end
