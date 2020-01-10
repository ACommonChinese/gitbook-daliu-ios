# responseToSelector

### 参考  
[https://exceptionshub.com/what-is-the-swift-equivalent-of-respondstoselector.html](https://exceptionshub.com/what-is-the-swift-equivalent-of-respondstoselector.html)

Swift是一个类型安全语言，每一次调用一个方法，Swift必须知道方法已经是存在的，Runtime检查不被允许。  
像responseToSelector:这种运行时检查方法是否存在在Swift是不被允许的， 如果一定要调用responseToSelector:判断方法是否存在，只要让Swift的类继承于NSObject, 从而变成NSObject的一部分：   

```swift
class Worker : NSObject {
    @objc func work() { }
}

let worker = Worker()
if worker.responds(to: #selector(Worker.work)) {
    print("YES")
}
```

相同方法名不同参数，可以用 as 区分    
```swift
let methodA = #selector(buttonActionA as () -> ())
let methodB = #selector(buttonActionB as (UIButton) -> ())
```

上面的responds(to:)的方法声明是：

```swift
func responds(to aSelector: Selector!) -> Bool
```

`#selector(Worker.work)`其实是一个Selector结构体，上面这种判断没有任何意义，因为此方法的Selector是`Selector!`加了叹号，是一定要存在的，判断是否方法存在就没有意义了。  

因此，在Swift中一般直接调用：  

```swift
//  https://exceptionshub.com/what-is-the-swift-equivalent-of-respondstoselector.html

import Foundation

protocol WorkerProtocol {
    func doIt() // 不支持optional关键字，'optional' can only be applied to members of an @objc protocol
}

class WorkerDelegate: WorkerProtocol {
    // 在swift中，声明某类实现了一个协议，则该类必须实现这个协议中的所有方法，
    // 因为swift协议没有optional, 'optional' can only be applied to members of an @objc protocol
    func doIt() {
        print("delegate do it")
    }
}

class Worker {
    weak var delegate: WorkerDelegate?
}

let worker = Worker()
let delegate = WorkerDelegate()

worker.delegate = delegate

if let _ = worker.delegate?.doIt() {
    print("实现并调用delegate的doIt()方法")
}
else {
    print("未实现")
}
```