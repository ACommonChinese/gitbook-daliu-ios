# @dynamic

先简要说明`@property`, `@property`和`@synthesize`往往是一对。

```
@interface Man : NSObject
@property (nonatomic, copy)NSString *name;
@end

#import "Man.h"

@implementation Man
@synthesize name = _name;

@end
```

这个结合`@property`的`@synthesize name = _name;`, 系统会为我们做三件事：
1. 声明一个成员变量`_name`
2. 生成形如下面方式的`setter`方法：
```Objective-C
- (void)setName:(NSString *)name {
    _name = [name copy];
}
```
3. 生成形如下面方式的`getter`方法：
```Objective-C
- (NSString *)name {
    return _name;
}
```

我们也可以不声明`@property`和`@synthesize`，通过上面这三步，同样可以调用`man.name`。

接下来看`@dynamic`，这在CoreData中很常见，使用`@dynamic`是我们对编译器的承诺，即告诉编译器属性的getter与setter不自动生成，而是在运行时提供属性的存取方法。如果一个属性被声明为`@dynamic`，则这个getter与setter必须由自己实现，系统不自动添加。

```Objective-C
@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@end

#import "Person.h"
@interface Person () {
    NSString *_name;
}
@end

@implementation Person
@dynamic name;
- (void)setName:(NSString *)name {
    _name = [name copy];
}
- (NSString *)name {
    return _name;
}
@end
```

由于我们对编译器作出了自己实现getter和setter的承诺，如果不实现，则运行时直接crash.

所有的 Core Data Model 类都是 NSManagedObject 的子类，它为我们实现了一整套的机制，可以利用我们定义的 Core Data 数据图和关系在运行时动态生成合适的 getter 和 setter 方法。在绝大多数情况下，我们只需要使用 Xcode 的工具自动生成 NSManagedObject 的子类并使用就行了。在 Objective-C 中一个典型的 NSManagedObject 子类的样子是这样的：

```Objective-C
// MyModel.h
@interface MyModel : NSManagedObject

@property (nonatomic, copy) NSString * title;

@end

// MyModel.m
#import "MyModel.h"
@implementation MyModel

@dynamic title;

@end
```

很遗憾，Swift 里是没有 @dynamic 关键字的，因为 Swift 并不保证一切都走动态派发，因此从语言层面上提供这种动态转发的语法也并没有太大意义。在 Swift 中严格来说是没有原来的 @dynamic 的完整的替代品的，但是如果我们将范围限定在 Core Data 的话就有所不同：

Core Data 是 Cocoa 的一个重要组成部分，也是非常依赖 @dynamic 特性的部分。Apple 在 Swift 中专门为 Core Data 加入了一个特殊的标注来处理动态代码，那就是 @NSManaged。我们只需要在 NSManagedObject 的子类的成员的字段上加上 @NSManaged 就可以了：

```Swift
class MyModel: NSManagedObject {
    @NSManaged var title: String
}
```

参考：
- [https://swifter.tips/core-data/](https://swifter.tips/core-data/)