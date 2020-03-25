//
//  BMModuleRouter.m
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMModuleRouter.h"

@implementation BMModuleRouter

+ (BMModuleRouter *)sharedRouter {
    static dispatch_once_t onceToken;
    static BMModuleRouter *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routers = [NSMutableDictionary<NSString *, BMModuleRouterInvocation *> dictionary];
        _modules = [NSMutableDictionary<NSString *, BMModuleRouterModule *> dictionary];
    }
    return self;
}

// 这个方法是在声明module时调用的
// 比如：@module(BMBindCarSDKModule);
- (void)addModule:(Class)targetClass, ... {
    if (targetClass) {
        // Unregister module first
        // 先移除和这个module相关联的invocation对象
        [self removeModule:targetClass];
        
        // 添加module对象
        va_list args;
        va_start(args, targetClass);
        BMModuleRouterModule *module = [[BMModuleRouterModule alloc] initWithClass:targetClass args:args];
        va_end(args);
        [self.modules setObject:module forKey:NSStringFromClass(targetClass)];
    }
}

// 移除和这个module相关联的invocation对象
- (void)removeModule:(Class)targetClass {
    if (targetClass) {
        BMModuleRouterModule *module = [self.modules objectForKey:NSStringFromClass(targetClass)];
        if (module) {
            NSMutableArray<NSString *> *urls = [NSMutableArray<NSString *> array];
            for (NSString *url in self.routers.allKeys) {
                BMModuleRouterInvocation *routeInvocation = [self.routers objectForKey:url];
                if (routeInvocation &&
                    routeInvocation.module &&
                    routeInvocation.module.targetClass == targetClass) {
                    [urls addObject:url];
                }
            }
            // 移除所有urls中标识的invocation对象
            for (NSString *url in urls) {
                [self.routers removeObjectForKey:url];
            }
        }
    }
}

- (void)addRouters:(BMModuleRouterModule *)module
              type:(BMModuleRouterInvocationType)invocationType {
    if (!module || !module.targetClass) {
        return;
    }
    
    // 获取方法
    unsigned int methodCount = 0;
    Class clazz = invocationType == BMModuleRouterInvocationTypeClass? object_getClass(module.targetClass) : module.targetClass;
    Method *methods = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        // Method
        Method method = methods[i];
        // 类名 Class name
        NSString *clazzName = [NSString stringWithUTF8String:class_getName(module.targetClass)];
        // 方法名 Sel name
        SEL sel = method_getName(method);
        NSString *selName = [NSString stringWithUTF8String:sel_getName(sel)];
        // Router url
        NSString *url = [NSString stringWithFormat:@"%@.%@", clazzName, selName];
        // 参数个数 Argument count
        unsigned int argumentCount = method_getNumberOfArguments(method);
        // 参数类型 Argument types
        
    }
}

// 示例： @module_call(BMLoginQRCodeViewModule.getLoginVehicleAuth:, vc)
// 根据 `BMLoginQRCodeViewModule.getLoginVehicleAuth:` 创建router, 即invocation对象
- (BMModuleRouterInvocation *)routerInvocation:(NSString *)url {
    BMModuleRouterInvocation *routerInvocation = [self.routers objectForKey:url];
    if (!routerInvocation) {
        NSArray<NSString *> *parts = [url componentsSeparatedByString:@"."];
        if (parts && parts.count > 1) {
            NSString *moduleClassName = parts.firstObject;
            // 必须先存在相应的module, 如果不存在，忽略
            BMModuleRouterModule *module = [self.modules objectForKey:moduleClassName];
            if (module) {
                // 为实例方法添加router
                
            }
        }
    }
    return routerInvocation;
}

@end


// __unsafe_unretained
