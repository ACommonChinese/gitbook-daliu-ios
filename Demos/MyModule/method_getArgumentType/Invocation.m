//
//  Invocation.m
//  method_getArgumentType
//
//  Created by liuxing8807@126.com-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "Invocation.h"
#import <objc/runtime.h>

@implementation Invocation

- (void *)invoke:(va_list)args {
    id target = [[self.targetClass alloc] init];
    if (self.invocationType == ZZModuleRouterInvocationTypeClass) {
        target = [target class];
    }
    // targt + selector ==> invocation
    SEL selector = NSSelectorFromString(self.selectorName);
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [self prepareArguments:invocation args:args];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    [invocation invoke];
    
    const char *returnType = [signature methodReturnType];
    // 这样也可以:
    // char ret[128];
    // method_getReturnType(Method  _Nonnull m, char * _Nonnull dst, size_t dst_len)
    // method_getReturnType(self.method, ret, sizeof(ret));
    
    return [self invocationReturnValue:invocation forReturnType:returnType];
}

- (void *)invocationReturnValue:(NSInvocation *)invocation forReturnType:(const char *)ret {
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

- (void)dealloc {
    if (self.argumentTypes != nil) {
        for (unsigned int i = 0; i < self.argumentCount; ++i) {
            free((char *)self.argumentTypes[i]);
        }
        free(self.argumentTypes);
    }
}

@end
