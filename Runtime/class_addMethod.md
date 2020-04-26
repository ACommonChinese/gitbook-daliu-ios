# class_addMethod

`class_addMethod`主要是为Class动态添加方法实现

```objective-c
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
```

参数 From Apple:
- cls: The class to which to add a method.
- name: A selector that specifies the name of the method being added.
- imp: A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
- types: An array of characters that describe the types of the arguments to the method. For possible values, see Objective-C Runtime Programming Guide > [Type Encodings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100). Since the function must take at least two arguments—self and _cmd, the second and third characters must be “@:” (the first character is the return type).

BOOL: 返回值, yes代表方法添加成功,  no代表方法添加失败  
Class cls: 是要添加方法的类, `[类名 class]`, 如果在类方法中可以直接传self也代表当前Class    
SEL name: 要添加的方法, `@selector(方法名)`或`NSSelectorFromString(@"方法名")`  
IMP imp：方法的实现函数, C写法`C语言写法：（IMP）方法名`, OC写法`class_getMethodImplementation(self,@selector(方法名：))`  
`const char *types`: 这个是一个字符数组, 即C格式的字符串, 表示要添加的方法的返回值和参数类型, 由于实现函数的前两个参数是`self`和`_cmd`, 通过对照[Type Encodings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100)可知分别对应`@`和`:`, 因此这个C字符串第一个字符是返回值 `type encode`, 第二个和第三个一定是`@:`, 比如`-(void)lear:(NSString *)subject`这个方法对应的types应当是: `v@:@`, 其中`v`代表返回值为`void`, 第二和第三个对应`self`和`_cmd`, 最后一个`@`代表参数是对象

-------------------------------

示例: 比如有一个Person类和一个实例方法 `- (void)learn:(NSString *)subject`, 声明代不实现:  

```objective-c
@interface Person : NSObject

- (void)learn:(NSString *)subject;

@end
```

```objective-c
#import "Person.h"
#import <objc/runtime.h>

@implementation Person

//- (void)learn:(NSString *)subject {
//    
//}

// 实例方法找不到时会走到这个地方
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(learn:)) {
        class_addMethod(self, sel, class_getMethodImplementation(self, @selector(reallyLearn:)), "v@:@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (void)reallyLearn:(NSString *)subject {
    NSLog(@"认真学习: %@", subject);
}

@end
```

这样当调用Person实例的learn:方法时就会走到reallyLearn:中  

由于type encoding手动打起来还是比较烦琐的, 根据从SEL可以得到Method, 从Method可以得到method的实现, 一般我们会简单封装一下:  

```objective-c
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
```