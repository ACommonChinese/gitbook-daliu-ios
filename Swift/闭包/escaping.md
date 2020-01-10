# escaping


参考：[https://www.jianshu.com/p/266c2370effd](https://www.jianshu.com/p/266c2370effd)

@escaping闭包被译为逃逸闭包，如果一个闭包被作为一个参数传递给一个函数，并且在函数return之后才被唤起执行，那么这个闭包是逃逸闭包。简单而言，使用@escaping修饰的逃逸闭包就是在函数return后执行的闭包（逃出到函数外执行），noescaping闭包就是在函数内执行的闭包（函数内执行，随函数的终结而终结）。

看一下不逃逸闭包的生命周期：

1. Pass a closure into a function
2. The function runs the closure (or not)
3. The function returns

然后这个closure就死掉了  

Swift3之后，传递给参数的闭包默认是non-escaping闭包，In Swift 3, closure parameters are non-escaping by default; you can use the new @escaping attribute if this isn’t what you want. Non-escaping closures passed in as arguments are guaranteed to not stick around once the function returns.

来看一个示例： 

```swift
public class ViewController : UIViewController {
    /// 声明一个属性作为闭包变量，这个是escaping闭包
    public var success: ((_ vc: ThirdViewController) -> Void)?
    
    public func setSuccess(callback: @escaping ((ThirdViewController) -> Void) {
        // Swift3之后，传递给参数的闭包默认是non-escaping闭包
        // 如果上面没有escaping修饰，编译器报错：Assigning non-escaping parameter 'callback' to an @escaping closure
        self.success = callback
    }
}
```