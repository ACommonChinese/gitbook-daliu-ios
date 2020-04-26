# ResolveMethod

由上文可知如果方法没有找到, 会走如下流程:  

```objective-c
// 第一阶段: 动态方法解析(Dynamic Method Resolution或Lazy method resolution)
// 动态方法解析(Dynamic Method Resolution或Lazy method resolution)
// 向当前类(Class)发送resolveInstanceMethod:(对于类方法则为resolveClassMethod:)消息，如果返回YES,则系统认为请求的方法已经加入到了，则会重新发送消息
+ (BOOL)resolveInstanceMethod:(SEL)sel {}
+ (BOOL)resolveClassMethod:(SEL)sel {}

// 第二阶段: 快速转发路径(Fast forwarding path)
// 若果当前target实现了forwardingTargetForSelector:方法,则调用此方法。如果此方法返回除nil和其他对象，则向返回对象重新发送消息
- (id)forwardingTargetForSelector:(SEL)aSelector {}

// 第三阶段: 慢速转发路径(Normal forwarding path)
// runtime发送methodSignatureForSelector:消息查看Selector对应的方法签名，即参数与返回值的类型信息。如果有方法签名返回，runtime则根据方法签名创建描述该消息的NSInvocation，向当前对象发送forwardInvocation:消息，以创建的NSInvocation对象作为参数；若methodSignatureForSelector:无方法签名返回，则向当前对象发送doesNotRecognizeSelector:消息,程序抛出异常退出
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {}
+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector {}
- (void)forwardInvocation:(NSInvocation *)anInvocation

// 第4阶段 crash
- (void)doesNotRecognizeSelector:(SEL)aSelector
```

--------------------------------------------------

先来看第一阶段:  **ResolveMethod**    

当向Objective-C对象发送一个消息，但runtime在当前类及父类中找不到此selector对应的方法时，消息转发(message forwarding)流程开始启动, 首先就是向当前类(Class)发送resolveInstanceMethod:(对于类方法则为resolveClassMethod:)消息，如果返回YES, 则系统认为请求的方法已经加入到了，会重新发送消息 

这个阶段主要是可以通过`class_addMethod`为方法动态的添加实现, 示例:  

```objective-c
@interface Person : NSObject

- (void)learn:(NSString *)subject;

@end

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

//- (void)learn:(NSString *)subject {
//    
//}

static inline BOOL zz_addMethod(Class cls, SEL sel, Method method) {
    return class_addMethod(cls, sel, method_getImplementation(method), method_getTypeEncoding(method));
}

// 实例方法找不到时会走到这个地方
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(learn:)) {
        return zz_addMethod(self, sel, class_getInstanceMethod(self, @selector(reallyLearn:)));
    }
    return [super resolveInstanceMethod:sel];
}

- (void)reallyLearn:(NSString *)subject {
    NSLog(@"认真学习: %@", subject);
}

@end

// 测试代码
- (void)test {
    Person *p = [[Person alloc] init];
    [p learn:@"Math"];
}
```

--------------------------------------------------

@dynamic属性也是使用动态解析的一个例子，@dynamic告诉编译器该属性对应的getter或setter方法会在运行时提供，所以编译器不会出现warning； 然后实现resolveInstanceMethod:方法在运行时将属性相关的方法加入到Class中

当respondsToSelector:或instancesRespondToSelector:方法被调用时，若该方法在类中未实现，动态方法解析器也会被调用，这时可向类中增加IMP,并返回YES,则对应的respondsToSelector:的方法也返回YES
