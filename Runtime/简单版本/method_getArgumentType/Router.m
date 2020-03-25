//
//  Router.m
//  method_getArgumentType
//
//  Created by banma-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "Router.h"
#import "Invocation.h"
#import <objc/runtime.h>

@interface Router ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, Invocation *> *routers;

@end

@implementation Router

+ (instancetype)sharedRouter {
    static dispatch_once_t onceToken;
    static Router *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _routers = [NSMutableDictionary<NSString *, Invocation *> dictionary];
    }
    return self;
}

- (void *)route:(NSString *)url, ... {
    Invocation *invocation = [self invocationForUrl:url];
    if (!invocation) {
        return nil;
    }
    va_list args;
    va_start(args, url);
    void *r = [invocation invoke:args];
    va_end(args);
    return r;
}

- (Invocation *)invocationForUrl:(NSString *)url {
    Invocation *invocation = [self.routers objectForKey:url];
    if (!invocation) {
        [self addInvocationForUrl:url type:BMModuleRouterInvocationTypeClass];
        [self addInvocationForUrl:url type:BMModuleRouterInvocationTypeInstance];
    }
    return [self.routers objectForKey:url];
}

- (void)addInvocationForUrl:(NSString *)url type:(BMModuleRouterInvocationType)invocationType {
    NSArray<NSString *> *parts = [url componentsSeparatedByString:@"."];
    
    // 类名
    NSString *className = parts.firstObject;
    if (className.length <= 0) return;
    Class originClass = NSClassFromString(className);
    if (originClass == nil) return;
    Class clazz = originClass;
    if (invocationType == BMModuleRouterInvocationTypeClass) {
        clazz = object_getClass(clazz); // meta class 中存储了类方法
    }

    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(clazz, &methodCount);
    // 每一个Method都对应一个Invocation对象
    for (unsigned int i = 0; i < methodCount; ++i) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *selectorStr = NSStringFromSelector(selector);
        NSString *url = [NSString stringWithFormat:@"%@.%@", className, selectorStr];
        unsigned int argumentCount = method_getNumberOfArguments(method);
        
        // 参数类型
        const char **argumentTypes = argumentCount > 2?
                   (const char **)malloc(sizeof(char *) * (argumentCount - 2)) : NULL;
        // 索引从2开始，索引0和1对应self和_cmd
        for (unsigned int j = 2; j < argumentCount; ++j) {
            char *type = (char *)malloc(128);
            method_getArgumentType(method, j, type, 128);
            argumentTypes[j-2] = type;
        }

        Invocation *invocation = [[Invocation alloc] init];
        invocation.targetClass = originClass;
        invocation.selectorName = NSStringFromSelector(selector);
        invocation.argumentCount = argumentCount - 2;
        invocation.argumentTypes = argumentTypes;
        invocation.invocationType = invocationType;
        // key: 类名.方法名
        // value: invocation对象
        [self.routers setObject:invocation forKey:url];
    }
    free(methods);
}

@end
