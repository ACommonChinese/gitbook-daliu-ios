///***************************************************************************************
// *
// *  Project:        BMModuleKit
// *
// *  Copyright ©     2014-2019 Banma Technologies Co.,Ltd
// *                  All rights reserved.
// *
// *  This software is supplied only under the terms of a license agreement,
// *  nondisclosure agreement or other written agreement with Banma Technologies
// *  Co.,Ltd. Use, redistribution or other disclosure of any parts of this
// *  software is prohibited except in accordance with the terms of such written
// *  agreement with Banma Technologies Co.,Ltd. This software is confidential
// *  and proprietary information of Banma Technologies Co.,Ltd.
// *
// ***************************************************************************************
// *
// *  Header Name: BMModuleRouter.m
// *
// *  General Description: Copyright and file header.
// *
// *  Created by Chris on 2019/2/19.
// *
// ****************************************************************************************/

#import "BMModuleRouter.h"
#import <objc/runtime.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 * @enum BMModuleRouterInvocationType
 *
 * @constant BMModuleRouterInvocationTypeInstance  Instance method
 * @constant BMModuleRouterInvocationTypeClass     Class method
 */
typedef NS_ENUM(NSInteger, BMModuleRouterInvocationType) {
    BMModuleRouterInvocationTypeInstance,
    BMModuleRouterInvocationTypeClass,
};

@class BMModuleRouterInvocation, BMModuleRouterModule;

#pragma mark -

@interface BMModuleRouterInvocation : NSObject

/**
 * @property module, A back-pointer to the module
 */
@property (nonatomic, assign) BMModuleRouterModule *module;

/**
 * @property method
 */
@property (nonatomic, assign) Method method;

/**
 * @property invocationType
 */
@property (nonatomic, assign) BMModuleRouterInvocationType invocationType;

/**
 * @property argumentCount
 */
@property (nonatomic, assign) unsigned int argumentCount;

/**
 * @property argumentTypes
 */
@property (nonatomic, assign) const char **argumentTypes;

/**
 * @method invoke:
 */
- (void *)invoke:(va_list)args;

@end

#pragma mark -

@interface BMModuleRouter ()

/**
 * @property routers
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, BMModuleRouterInvocation *> *routers;

/**
 * @property modules
 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, BMModuleRouterModule *> *modules;

@end

#pragma mark -

@interface BMModuleRouterModule : NSObject

/**
 * @property targetClass
 */
@property (nonatomic, strong) Class targetClass;

/**
 * @property target, Cached module target instance
 */
@property (nonatomic, strong) id target;

/**
 * @property shouldCache, Should cache target instance
 */
@property (nonatomic, assign) BOOL shouldCache;

/**
 * @method initWithClass:args:
 */
- (instancetype)initWithClass:(Class)moduleClass args:(va_list)args;

@end

#pragma mark -

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

- (void)addModule:(Class)targetClass, ... {
    if (targetClass) {
        // Unregister module first
        [self removeModule:targetClass];
        
        // Add module again
        va_list args;
        va_start(args, targetClass);
        BMModuleRouterModule *module = [[BMModuleRouterModule
                                         alloc] initWithClass:targetClass args:args];
        va_end(args);
        [self.modules setObject:module forKey:NSStringFromClass(targetClass)];
    }
}

- (void)removeModule:(Class)targetClass {
    if (targetClass) {
        BMModuleRouterModule *module = [self.modules objectForKey:NSStringFromClass(targetClass)];
        if (module) {
            // Remove all routers for the module
            NSMutableArray<NSString *> *urls = [NSMutableArray<NSString *> array];
            for (NSString *url in self.routers.allKeys) {
                BMModuleRouterInvocation *routeInvocation = [self.routers objectForKey:url];
                if (routeInvocation &&
                    routeInvocation.module &&
                    routeInvocation.module.targetClass == targetClass) {
                    [urls addObject:url];
                }
            }
            // Remove all routes related to the urls
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
    
    // Retrive methods
    unsigned int methodCount = 0;
    Class clazz = invocationType == BMModuleRouterInvocationTypeClass?
        object_getClass(module.targetClass) : module.targetClass;
    Method *methods = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; ++i) {
        // Method
        Method method = methods[i];

        // Class name
        NSString *clazzName = [NSString stringWithUTF8String:class_getName(module.targetClass)];

        // Sel name
        NSString *selName = [NSString stringWithUTF8String:sel_getName(method_getName(method))];

        // Router url
        NSString *url = [NSString stringWithFormat:@"%@.%@", clazzName, selName];

        // Argument count
        unsigned int argumentCount = method_getNumberOfArguments(method);

        // Argument types
        const char **argumentTypes = argumentCount > 2?
            (const char **)malloc(sizeof(char *) * (argumentCount - 2)) : NULL;

        // Retrive from index 2, because the first and second is return value and sel
        for (unsigned int j = 2; j < argumentCount; ++j) {
            char *type = (char *)malloc(128);//new char[128];
            method_getArgumentType(method, j, type, sizeof(type));
            argumentTypes[j - 2] = type;
        }
        
        // Create a router invocation object
        BMModuleRouterInvocation *routerInvocation = [[BMModuleRouterInvocation alloc] init];
        routerInvocation.module = module;
        routerInvocation.method = method;
        routerInvocation.argumentCount = argumentCount - 2;
        routerInvocation.argumentTypes = argumentTypes;
        routerInvocation.invocationType = invocationType;
        
        // Add to cache
        [self addRouter:url invocation:routerInvocation];
    }
}

- (void)addRouter:(NSString *)url invocation:(BMModuleRouterInvocation *)routerInvocation {
    if (routerInvocation && url && [url isKindOfClass:[NSString class]] && url.length > 0) {
        [self.routers setObject:routerInvocation forKey:url];
    }
}

- (void *)route:(NSString *)url, ... {
    // Check and validate url
    url = [[url componentsSeparatedByCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]]
           componentsJoinedByString:@""];
    
    // Get router invocation by url
    BMModuleRouterInvocation *routerInvocation = [self routerInvocation:url];
    if (routerInvocation) {
        void *r = nil;
        va_list args;
        va_start(args, url); {
            r = [routerInvocation invoke:args];
        }
        va_end(args);
        return r;
    }
    return nil;
}

- (BMModuleRouterInvocation *)routerInvocation:(NSString *)url {
    BMModuleRouterInvocation *routerInvocation = [self.routers objectForKey:url];
    if (!routerInvocation) {
        NSArray<NSString *> *parts = [url componentsSeparatedByString:@"."];
        if (parts && parts.count > 1) {
            NSString *moduleClassName = parts.firstObject;
            BMModuleRouterModule *module = [self.modules objectForKey:moduleClassName];
            if (module) {
                // Add routers for instance methods
                [self addRouters:module type:BMModuleRouterInvocationTypeInstance];
                // Add routers for class methods
                [self addRouters:module type:BMModuleRouterInvocationTypeClass];
                // Get back again
                routerInvocation = [self.routers objectForKey:url];
            }
        }
    }
    return routerInvocation;
}

- (id)target:(NSString *)url {
    // Check and validate url
    url = [[url componentsSeparatedByCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]]
           componentsJoinedByString:@""];
    
    // Get router invocation by url
    BMModuleRouterInvocation *routerInvocation = [self routerInvocation:url];
    if (routerInvocation) {
        BMModuleRouterModule *module = routerInvocation.module;
        return module.target ?: [[module.targetClass alloc] init];
    }
    return nil;
}

@end

#pragma mark -

@implementation BMModuleRouterInvocation

- (instancetype)init {
    self = [super init];
    if (self) {
        _argumentTypes = nil;
    }
    return self;
}

- (void *)invoke:(va_list)args {
    // Create a module instance
    id target = self.module.target ?: [[self.module.targetClass alloc] init];
    
    // Check invocation type
    if (self.invocationType == BMModuleRouterInvocationTypeClass) {
        target = [target class];
    }
    
    // SEL from method
    SEL sel = method_getName(self.method);
    
    // Get method signature
    NSMethodSignature *signature = [target methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    // Prepare invocation arguments
    [self prepareArguments:invocation args:args];
    
    // Invocation invoke
    [invocation setTarget:target];
    [invocation setSelector:sel];
    [invocation invoke];
    
    // Invocation return value
    return [self invocationReturnValue:invocation];
}

- (void)prepareArguments:(NSInvocation *)invocation args:(va_list)args {
    for (unsigned int k = 0; k < self.argumentCount; ++k) {
        const char *type = self.argumentTypes[k];
        // int type
        if (strcmp(type, @encode(char)) == 0) {
            char c = va_arg(args, int);
            [invocation setArgument:&c atIndex:k + 2];
        }
        else if (strcmp(type, @encode(short)) == 0) {
            short st = va_arg(args, int);
            [invocation setArgument:&st atIndex:k + 2];
        }
        else if (strcmp(type, @encode(int)) == 0) {
            int i = va_arg(args, int);
            [invocation setArgument:&i atIndex:k + 2];
        }
        else if (strcmp(type, @encode(bool)) == 0) {
            bool b = va_arg(args, int);
            [invocation setArgument:&b atIndex:k + 2];
        }
        else if (strcmp(type, @encode(BOOL)) == 0) {
            BOOL b = va_arg(args, int);
            [invocation setArgument:&b atIndex:k + 2];
        }
        // unsigned int type
        else if (strcmp(type, @encode(unsigned char)) == 0) {
            unsigned char usc = va_arg(args, unsigned int);
            [invocation setArgument:&usc atIndex:k + 2];
        }
        else if (strcmp(type, @encode(unsigned short)) == 0) {
            unsigned short ust = va_arg(args, unsigned int);
            [invocation setArgument:&ust atIndex:k + 2];
        }
        else if (strcmp(type, @encode(unsigned int)) == 0) {
            unsigned int ui = va_arg(args, unsigned int);
            [invocation setArgument:&ui atIndex:k + 2];
        }
        // NSInteger type
        else if (strcmp(type, @encode(NSInteger)) == 0) {
            NSInteger nsi = va_arg(args, NSInteger);
            [invocation setArgument:&nsi atIndex:k + 2];
        }
        // NSUInteger type
        else if (strcmp(type, @encode(NSUInteger)) == 0) {
            NSUInteger unsi = va_arg(args, NSUInteger);
            [invocation setArgument:&unsi atIndex:k + 2];
        }
        // long type
        else if (strcmp(type, @encode(long)) == 0) {
            long l = va_arg(args, long);
            [invocation setArgument:&l atIndex:k + 2];
        }
        // unsigined long type
        else if (strcmp(type, @encode(unsigned long)) == 0) {
            unsigned long ul = va_arg(args, unsigned long);
            [invocation setArgument:&ul atIndex:k + 2];
        }
        else if (strcmp(type, @encode(long long)) == 0) {
            long long ll = va_arg(args, long long);
            [invocation setArgument:&ll atIndex:k + 2];
        }
        // unsigned long long type
        else if (strcmp(type, @encode(unsigned long long)) == 0) {
            unsigned long long ull = va_arg(args, unsigned long long);
            [invocation setArgument:&ull atIndex:k + 2];
        }
        // double type
        else if (strcmp(type, @encode(float)) == 0) {
            float f = va_arg(args, double);
            [invocation setArgument:&f atIndex:k + 2];
        }
        else if (strcmp(type, @encode(double)) == 0) {
            double d = va_arg(args, double);
            [invocation setArgument:&d atIndex:k + 2];
        }
        // char * type
        else if (strcmp(type, @encode(char *)) == 0) {
            char *cp = va_arg(args, char *);
            [invocation setArgument:&cp atIndex:k + 2];
        }
        // Class type
        else if (strcmp(type, @encode(Class)) == 0) {
            Class clazz = va_arg(args, Class);
            [invocation setArgument:&clazz atIndex:k + 2];
        }
        // SEL type
        else if (strcmp(type, @encode(SEL)) == 0) {
            SEL sel = va_arg(args, SEL);
            [invocation setArgument:&sel atIndex:k + 2];
        }
        // Block type
        else if (strcmp(type, @encode(void(^)(void))) == 0) {
            void *vp = va_arg(args, void *);
            [invocation setArgument:&vp atIndex:k + 2];
        }
        // if no matched, use void * type
        else {
            void *vp = va_arg(args, void *);
            [invocation setArgument:&vp atIndex:k + 2];
        }
    }
}

- (void *)invocationReturnValue:(NSInvocation *)invocation {
    // Return type
    char ret[128];
    method_getReturnType(self.method, ret, sizeof(ret));
    
    if (strcmp(ret, @encode(void)) == 0) {
        return nil;
    } else if (strcmp(ret, @encode(char)) == 0) {
        char c;
        [invocation getReturnValue:&c];
        return (__bridge void *)@(c);
    } else if (strcmp(ret, @encode(unsigned char)) == 0) {
        unsigned char uc;
        [invocation getReturnValue:&uc];
        return (__bridge void *)@(uc);
    } else if (strcmp(ret, @encode(short)) == 0) {
        short st;
        [invocation getReturnValue:&st];
        return (__bridge void *)@(st);
    } else if (strcmp(ret, @encode(unsigned short)) == 0) {
        unsigned short ust;
        [invocation getReturnValue:&ust];
        return (__bridge void *)@(ust);
    } else if (strcmp(ret, @encode(int)) == 0) {
        int i;
        [invocation getReturnValue:&i];
        return (__bridge void *)@(i);
    } else if (strcmp(ret, @encode(unsigned int)) == 0) {
        unsigned int ui;
        [invocation getReturnValue:&ui];
        return (__bridge void *)@(ui);
    } else if (strcmp(ret, @encode(float)) == 0) {
        float f;
        [invocation getReturnValue:&f];
        return (__bridge void *)@(f);
    } else if (strcmp(ret, @encode(double)) == 0) {
        double d;
        [invocation getReturnValue:&d];
        return (__bridge void *)@(d);
    } else if (strcmp(ret, @encode(long)) == 0) {
        long l;
        [invocation getReturnValue:&l];
        return (__bridge void *)@(l);
    } else if (strcmp(ret, @encode(unsigned long)) == 0) {
        unsigned long ul;
        [invocation getReturnValue:&ul];
        return (__bridge void *)@(ul);
    } else if (strcmp(ret, @encode(long long)) == 0) {
        long long ll;
        [invocation getReturnValue:&ll];
        return (__bridge void *)@(ll);
    } else if (strcmp(ret, @encode(unsigned long long)) == 0) {
        unsigned long long ull;
        [invocation getReturnValue:&ull];
        return (__bridge void *)@(ull);
    } else if (strcmp(ret, @encode(bool)) == 0) {
        bool b;
        [invocation getReturnValue:&b];
        return (__bridge void *)@(b);
    } else if (strcmp(ret, @encode(BOOL)) == 0) {
        BOOL B;
        [invocation getReturnValue:&B];
        return (__bridge void *)@(B);
    } else if (strcmp(ret, @encode(NSInteger)) == 0) {
        NSInteger nsi;
        [invocation getReturnValue:&nsi];
        return (__bridge void *)@(nsi);
    } else if (strcmp(ret, @encode(CGFloat)) == 0) {
        CGFloat cgf;
        [invocation getReturnValue:&cgf];
        return (__bridge void *)@(cgf);
    } else if (strcmp(ret, @encode(id)) == 0) {
        id o = nil;
        [invocation getReturnValue:&o];
        return (__bridge_retained void *)(o);
    } else if (strcmp(ret, @encode(Class)) == 0) {
        Class clazz;
        [invocation getReturnValue:&clazz];
        return (__bridge void *)(clazz);
    } else if (strcmp(ret, @encode(char *)) == 0) {
        char *cp;
        [invocation getReturnValue:&cp];
        return cp;
    } else if (strcmp(ret, @encode(SEL)) == 0) {
        SEL sel;
        [invocation getReturnValue:&sel];
        return sel;
    } else if (strcmp(ret, @encode(IMP)) == 0) {
        IMP imp;
        [invocation getReturnValue:&imp];
        return imp;
    } else if (strcmp(ret, @encode(void *)) == 0) {
        void *r;
        [invocation getReturnValue:&r];
        return r;
    } else if (strcmp(ret, @encode(void(^)(void))) == 0) {
        void *r;
        [invocation getReturnValue:&r];
        return r;
    } else {
        void *r;
        [invocation getReturnValue:&r];
        return r;
    }
    return nil;
}

- (void)dealloc {
    if (self.argumentTypes != nil) {
        for (unsigned int i = 0; i < self.argumentCount; ++i) {
            free((char *)self.argumentTypes[i]);
        }
        free(self.argumentTypes);
    }
}

@end

#pragma mark -

@implementation BMModuleRouterModule

- (instancetype)initWithClass:(Class)targetClass args:(va_list)args {
    self = [super init];
    if (self) {
        _targetClass = targetClass;
        _shouldCache = va_arg(args, int);
    }
    return self;
}

- (id)target {
    if (_shouldCache && !_target) {
        _target = [[self.targetClass alloc] init];
    }
    return _target;
}

@end

