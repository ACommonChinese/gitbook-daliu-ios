# Toll-free bridging

ARC环境下，编译器不会自动管理CoreFoundation对象的内存，需要手动管理, Toll-free bridging 是ARC下OC对象和Core Foundation对象之间的桥梁
可以通过`__bridge, __bridge_transfer, __bridge_retained`来进行内存管理.
`__bridge`一般用在只涉及对象类型不涉及对象所有权的转化
`__bridge_transfer`做的是release操作，一般在CF对象转化成OC对象时使用
`__bridge_retained`做的是retain操作，一般在OC对象转化成CF对象时使用

**__bridge**

```Objective-C
// CF和OC对象转化时只涉及对象类型不涉及对象所有权的转化
// Image I/O 从 NSBundle 读取图片数据
NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"];
CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"image" ofType:@"png"]], NULL);
```

**__bridge_transfer**

```Objective-C
常用在CF对象转化成OC对象时，将CF对象的所有权交给OC对象，此时ARC就能自动管理该内存,作用同CFBridgingRelease()
如果非ARC的时候，我们可能需要写下面的代码:
// p 变量原先持有对象的所有权
id obj = (id)p;
[obj retain];
[(id)p release];

ARC有效后，我们可以用下面的代码来替换：
// p 变量原先持有对象的所有权
id obj = (__bridge_transfer id)p;
```

`__bridge_transfer`移交所有权，一般可以用`CFBridgingRelease`代替：
```Objective-C
NS_INLINE id _Nullable CFBridgingRelease(CFTypeRef CF_CONSUMED _Nullable X) {
    return (__bridge_transfer id)X;
}
```

**__bridge_retained**

常用在将OC对象转化成CF对象，且OC对象的所有权也交给CF对象来管理，即OC对象转化成CF对象时，涉及到对象类型和对象所有权的转化，作用同CFBridgingRetain()

```C
id obj = [[NSObject alloc] init];
void *p = (__bridge_retained void *)obj;
```

此时retainCount 会被加1；
从名字上我们应该能理解其意义：类型被转换时，其对象的所有权也将被变换后变量所持有。如果不是ARC代码，类似下面的实现：

```Objective-C
id obj = [[NSObject alloc] init];
void *p = obj;
[(id)p retain];
```

`__bridge_retained`一般可用CFBridgingRetain代替, `CFBridgingRetain`定义：

```Objective-C
// After using a CFBridgingRetain on an NSObject, the caller must take responsibility for calling CFRelease at an appropriate time.
NS_INLINE CF_RETURNS_RETAINED CFTypeRef _Nullable CFBridgingRetain(id _Nullable X) {
    return (__bridge_retained CFTypeRef)X;
}
```

