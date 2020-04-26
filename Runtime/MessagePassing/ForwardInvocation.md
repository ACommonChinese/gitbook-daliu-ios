# ForwardInvocation

这一阶段也被称为慢速转发(Normal Forwarding)

resolve method(动态解析) 和 forwarding target(快速转发), 是对消息转发的优化，如果你不使用上述两种方式，则会进入完整的消息转发流程。这会创建一个NSInvocation对象来完全包含发送的消息，其中包括 target,selector,所有的参数, 以及返回值。  

示例:  

```objective-c
@interface Person : NSObject

- (instancetype)initWithName:(NSString *)name;
- (void)learn:(NSString *)subject;

@end

#import "Person.h"

@interface Person()

@property (nonatomic, copy) NSString *name;

@end

@implementation Person

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    self.name = name;
    return self;
}

- (void)learn:(NSString *)subject {
    NSLog(@"%@: Happy deep learn %@", self.name, subject);
}

@end
```

```objective-c
@interface NSArray (Util)

- (void)learn:(NSString *)subject;

@end

#import "NSArray+Util.h"

@implementation NSArray (Util)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        for (id obj in self) {
            if ((sig = [obj methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id obj in self) {
        [anInvocation invokeWithTarget:obj];
    }
}

@end
```

```objective-c
#import "NSArray+Util.h"

@implementation NSArray (Util)

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    if (!sig) {
        for (id obj in self) {
            if ((sig = [obj methodSignatureForSelector:aSelector])) {
                break;
            }
        }
    }
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    for (id obj in self) {
        [anInvocation invokeWithTarget:obj];
    }
}

@end
```