# Log

在Objective-C中，假如我们要Log方法名，第几行代码，可以用宏定义：

```Objective-C
#ifdef DEBUG
#define MyLog(fmt, ...) NSLog((@"log method: %s line: %d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define MyLog(fmt, ...)
#endif

#endif /* BMAccount_pch */
```

在 Swift 中，编译器为我们准备了几个很有用的编译符号，用来处理类似这样的需求:

| 符号  | 类型 | 描述 |
| ------------- | ------------- | ------------- |
| #file  | String  | 包含这个符号的文件的路径  |
| #line  | Int  | 符号出现处的行号  |
| #column  | Int  | 符号出现处的列 |
| #function  | String  | 包含这个符号的方法名字  |

```Swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        print("#file --> ", #file) // /Users/daliu/Desktop/demos/TestLog/ViewController.swift
        print("line --> ", #line)
        print("column --> ", #line)
        print("function --> ", #function)   // viewDidLoad()
    }
}
```

```Swift
func myLog<T>(message: T,
                  file: String = #file,
                  method: String = #function,
                  line: Int = #line) {
        #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
```

参考：

- [swifter.tips](https://swifter.tips/log/)
- [Apple](https://docs.swift.org/swift-book/ReferenceManual/Expressions.html)



