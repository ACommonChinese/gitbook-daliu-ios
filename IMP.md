# IMP

搞这个东西之前先来回顾一下C的函数指针：

```
// 声明一个函数指针类型P，它指向一个'返回值为int, 接收两个int参数的函数地址'
typedef int (*P)(int, int);

int sum(int a, int b) {
    return a + b;
}

int minus(int a, int b) {
    return a - b;
}

int multiply(int a, int b) {
    return a * b;
}

int divide(int a, int b) {
    return a/b;
}

void printValue(int a, int b, P method) {
    int value = method(a, b);
    printf("%d\n", value);
}

int main(int argc, const char * argv[]) {
    int a = 10, b = 5;
    printValue(a, b, sum); // 15
    printValue(a, b, minus); // 5
    printValue(a, b, multiply); // 50
    printValue(a, b, divide); // 2
    return 0;
}
```

IMP也是一个指向函数实现地址的指针类型，该指针指向的函数满足"返回值为id”, 参数为(id, SEL, 参数列表)", 由于IMP指向函数实现，因此可以使用它直接调用实现方法。

```C
typedef id (*IMP)(id, SEL, ...);
```

SEL和IMP有本质的区别。
一个方法有方法名和方法实现，SEL可以理解为方法标签名，而IMP就是具体的实现。
SEL只和方法标签格式有关，并不绑定类，对于一个多态的方法，可以用同一个SEL去调用。
IMP是Implement的缩写，指向方法实现的地址。

IMP 是一个函数指针类型，这个被指向的函数包含一个接收消息的对象id(self  指针), 调用方法的选标 SEL (方法名)，以及不定个数的方法参数，并返回一个id。也就是说 IMP 是消息最终调用的执行代码，是方法真正的实现代码。
实际根据SEL来调用方法的过程是选通过SEL在类里找到对应的IMP然后由IMP去调用方法。

```
IMP imp = [anObj instanceMethodForSelector:@selector(hello:)];
```
这个方法返回anObj对象的实例方法`hello:`的实现地址。
Locates and returns the address of the implementation of the instance method identified by a given selector. An error is generated if instances of the receiver can’t respond to aSelector messages.

```
IMP imp = [objOrClass methodForSelector:@selector(hello:)];
```
这个方法返回objOrClass的方法`hello:`的实现地址, objOrClass可以是实例，也可以是类，如果是实例，则返回实例方法实现地址，否则返回类方法实现地址。If the receiver is an instance, aSelector should refer to an instance method; if the receiver is a class, it should refer to a class method.

使用IMP可以直接调用方法示例：

```
@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age;

@end

@implementation Person

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age {
    Person *p = [[self alloc] init];
    p.name = name;
    p.age = age;
    return p;
}

@end
```

```
SEL selector = @selector(personWithName:age:);
IMP imp = [Person methodForSelector:selector];
Person *p = ((id (*)(id, SEL, NSString *, NSInteger))imp)(Person.class, selector, @"daliu", 30); // 这相当于[Person personWithName:@"daliu", 30]
NSLog(@"%@", p.name);
```





