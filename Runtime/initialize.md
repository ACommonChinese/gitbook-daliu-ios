# initialize

参考: 

- [https://www.jianshu.com/p/135504ba18fe](https://www.jianshu.com/p/135504ba18fe)
- [https://stackoverflow.com/questions/13326435/nsobject-load-and-initialize-what-do-they-do](https://stackoverflow.com/questions/13326435/nsobject-load-and-initialize-what-do-they-do)

先来回顾一下+load方法, 以和+initialize作区别  

1. 当类或分类category添加到object-c runtime时, `+load`方法被调用, 子类的`+load`方法会在它所有父类的`+load`方法之后执行, 而分类的+load方法会在它的主类的+load方法之后执行。虽然load方法可以保证只调用一次, 但不同的类之间的+load方法的调用顺序是不确定的，所以最好不要在此方法中用另一个类  

2. +load方法不像普通方法一样，它不遵循那套继承规则。如果某个类本身没有实现+load方法，那么不管其它各级超类是否实现此方法，系统都不会调用。也就是说, 如果某个类本身没有`+load`方法, 但父类实现了, 那么并不会在加载这个类时调用父类的load方法, 而是只有在加载父类时, 父类自己的load方法才会被调用, +load方法调用顺序是：`SuperClass -->SubClass --> CategaryClass`  

3. 在类或者它的子类接受第一条消息前, `+initialize`方法被调用, 但是这发生在它的超类接收到initialize之后. `+initialize`方法是以懒加载的方式被调用的，如果程序一直没有给某个类或它的子类发送消息，那么这个类的+initialize方法是不会被调用的  

4. +initialize方法和+load方法还有个区别，就是运行期系统完整度上来讲，此时可以安全使用并调用任意类中的任意方法。而且，运行期系统也能确保+initialize方法一定会在“线程安全的环境”中执行，这就是说，只有执行+initialize的那个线程可以操作类或类实例，其他线程都要阻塞等着+initialize执行完

5. `+initialize`方法和其他类一样，如果某个类未实现它, 而其超类实现了，那么就会运行超类的实现代码。如果本身和超类都没有实现，超类的分类实现了，就会去调用分类的initialize方法, 如果本身没有实现，超类和父类的分类实现了就会去调分类的initialize方法。不管是在超类中还是分类中实现initialize方法都会被调多次，调用顺序是`SuperClass -->SubClass`   

|  | + load | + initialize |
| :------------ |:---------------| :-----|
| 执行时机    | 在程序运行后立即执行(main之前) | 在类的方法第一次被调用之前执行 |
| 若自身未定义, 是否沿用父类的方法 | 否       |   $12 |
| zebra stripes | are neat        |    $1 |

作一个试验, 写一个Animal类和它的扩展类, 再写一个Animal的扩展类Cat以及Cat的扩展类, 调用Cat实例的方法, 查看intitialize方法的调用  

```objective-c

@interface Animal : NSObject   
@end

@implementation Animal

+ (void)initialize {
    NSLog(@"Animal initialize");
}

@end

@interface Animal (Eatable)  @end

@implementation Animal (Eatable)

+ (void)initialize {
    NSLog(@"Animal initialize");
}

@end

@interface Cat : Animal

- (void)eat;

@end

@implementation Cat

- (void)eat {
    NSLog(@"-------------- Cat eat");
}

+ (void)initialize {
    NSLog(@"Cat initialize");
}

@end

@interface Cat (Eatable)

@end

@implementation Cat (Eatable)

+ (void)initialize {
    NSLog(@"Cat (Eatable) initialize");
}

@end

  int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        NSLog(@"main");
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        NSLog(@"main");
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Cat *cat = Cat.new;
    [cat eat];
}
```

程序打印:  

```
main
Animal (Eatable) initialize
Cat (Eatable) initialize
-------------- Cat eat
```

可见, 调用[cat etat]时, 本应先执行父类Animal的 initialize, 但由于Animal的Category也实现了 initialize, 因此执行`Animal (Eatable) initialize`, 再接下来本应执行Cat的 initialize, 但由于Cat的Category也实现了initialize, 因此执行`Cat (Eatable) initialize`, 之后执行到Cat的eat方法体
