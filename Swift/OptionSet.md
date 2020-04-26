# OptionSet

### Option运用环境

很多时候开发者会遇到一种情况，某个东西它有很多类型，但是在不同的情况下，这些类型或者所需要的值不确定，可能只需要其中一个， 也可能需要两个，三个，或者更多。这样就会有很多种组合出现，在编写程序时一一列出不太现实，这个时候就会用到Option。

### Option在OC中的用法

```Objective-C
typedef enum {
    HIShareTypeMaskUndefined = 0x0,
    HIShareTypeMaskTwitter = 0x1,
    HIShareTypeMaskFacebook = 0x1 << 1,
    HIShareTypeMaskGoogle = 0x01 << 2,
    HIShareTypeMaskWeChat = 0x01 << 3
} HIShareTypeMask;
```

不过Apple更推荐使用Option的写法: 

```Objective-C
typedef NS_OPTIONS(NSUInteger, HIShareTypeMask) {
    HIShareTypeMaskUndefined = 0x0,
    HIShareTypeMaskTwitter = 0x1,
    HIShareTypeMaskFacebook = 0x1 << 1,
    HIShareTypeMaskGoogle = 0x01 << 2,
    HIShareTypeMaskWeChat = 0x01 << 3
};
```

其实都是一样的，只是写法不同而已。

表示其中两种的组合：

```Objective-C
NSInteger shareTypes1 = HIShareTypeMaskUndefined;
shareTypes1 = shareTypes1 | HIShareTypeMaskTwitter;
NSInteger shareTypes2 = shareTypes1 | HIShareTypeMaskFacebook;
NSInteger shareTypes3 = shareTypes2 | HIShareTypeMaskGoogle;
NSLog(@"%ld",(long)shareTypes1);
NSLog(@"%ld",(long)shareTypes2);
NSLog(@"%ld",(long)shareTypes3);
```

若要判断某个组合中是否包含一个或多个枚举值，那就需要用到“&”按位与运算符:

```Objective-C
if (shareTypes3 & HIShareTypeMaskTwitter) {
    NSLog(@"111");
}
if (shareTypes3 & shareTypes2) {
    NSLog(@"222");
}
if (shareTypes3 & HIShareTypeMaskWeChat) {
    NSLog(@"333");
}
```

# 在Swift中的运用

由于`|`和`&`是C语言的运算符，OC和C是可以混编，但是Swift不能和C语言混编，所以在swift中已经没有`|`和`&`这样的运算了 （在Swift1.0中任然可以使用，那时声明的RawOptionsetType协议，但在Swift2.0后就取消了）。在Swift中使用的是OptionSet协议

```swift
struct OptionTest: OptionSet {
    var rawValue: UInt8
    static let Sunday = OptionTest(rawValue: 1 << 0)
    static let Monday = OptionTest(rawValue: 1 << 1)
    static let Tuesday = OptionTest(rawValue: 1 << 2)
    static let Wednesday = OptionTest(rawValue: 1 << 3)
    static let Thursday = OptionTest(rawValue: 1 << 4)
    static let Friday = OptionTest(rawValue: 1 << 5)
    static let Saturday = OptionTest(rawValue: 1 << 6)
}
```

若要表示某几种的组合，使用的是数组:

```swift
let one: OptionTest = [OptionTest.Twitter, OptionTest.Facebook, OptionTest.Google]
```

若判断某个组合中是否包含了一个或多个类型:

```swift
one.contains(OptionTest.Twitter)
one.contains([OptionTest.Twitter, OptionTest.Google])
one.contains([OptionTest.Google, OptionTest.WeChat])
```

在实战中经常遇到Option作为参数的运用。比如给一个view设置一个或两个圆角：

在OC中：

```Objective-C
UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight  cornerRadii:CGSizeMake(10, 10)];
```

在Swift中：

```Swift
let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.bottomRight,.bottomLeft], cornerRadii: CGSize(width: 10, height: 10))
```