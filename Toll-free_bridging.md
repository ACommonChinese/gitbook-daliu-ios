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

**swift的toll-free bridging和unmanaged**

[参考王巍博客](https://swifter.tips/toll-free/)

我们在把对象在 NS 和 CF 之间进行转换时，需要向编译器说明是否需要转移内存的管理权。对于不涉及到内存管理转换的情况，在 Objective-C 中我们就直接在转换的时候加上 __bridge 来进行说明，表示内存管理权不变。

```
NSURL *fileURL = [NSURL URLWithString:@"SomeURL"];
SystemSoundID theSoundID;
//OSStatus AudioServicesCreateSystemSoundID(CFURLRef inFileURL,
//                             SystemSoundID *outSystemSoundID);
OSStatus error = AudioServicesCreateSystemSoundID(
        (__bridge CFURLRef)fileURL,
        &theSoundID);
```

而在 Swift 中，这样的转换可以直接省掉了，上面的代码可以写为下面的形式，简单了许多：

```
import AudioToolbox

let fileURL = NSURL(string: "SomeURL")
var theSoundID: SystemSoundID = 0

//AudioServicesCreateSystemSoundID(inFileURL: CFURL,
//        _ outSystemSoundID: UnsafeMutablePointer<SystemSoundID>) -> OSStatus
AudioServicesCreateSystemSoundID(fileURL!, &theSoundID)
```

在OC中，对于 CF 系的 API，如果 API 的名字中含有 Create，Copy 或者 Retain 的话，在使用完成后，我们需要调用 CFRelease 来进行释放。在Swift中CF 现在也在 ARC 的管辖范围之内了。其实背后的机理一点都不复杂，只不过在合适的地方加上了像 CF_RETURNS_RETAINED 和 CF_RETURNS_NOT_RETAINED 这样的标注。

```
// CFGetSomething() -> Unmanaged<Something>
// CFCreateSomething() -> Unmanaged<Something>
// 两者都没有进行标注，Create 中进行了创建

let unmanaged = CFGetSomething()
let something = unmanaged.takeUnretainedValue()
// something 的类型是 Something，直接使用就可以了

let unmanaged = CFCreateSomething()
let something = unmanaged.takeRetainedValue()

// 使用 something

//  因为在取值时 retain 了，使用完成后进行 release
unmanaged.release()
```

这些只有在没有标注的极少数情况下才会用到，如果你只是调用系统的 CF API，而不会去写自己的 CF API 的话，是没有必要关心这些的

