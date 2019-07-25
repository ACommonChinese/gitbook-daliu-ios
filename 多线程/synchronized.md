# synchronize

摘自[这里](https://swifter.tips/lock/)

OC中的synchronized:

```Objective-C
- (void)myMethod:(id)anObj {
    @synchronized(anObj) { // 自动加上和解除互斥锁
        // 在括号内 anObj 不会被其他线程改变
    }
}
```

其实 @synchronized 在幕后做的事情是调用了 objc_sync 中的 objc_sync_enter 和 objc_sync_exit 方法，并且加入了一些异常判断。因此，在 Swift 中，如果我们忽略掉那些异常的话，我们想要 lock 一个变量的话，可以这样写：

```swift
func myMethod(anObj: AnyObject!) {
    objc_sync_enter(anObj)

    // 在 enter 和 exit 之间 anObj 不会被其他线程改变

    objc_sync_exit(anObj)
}
```

更进一步，如果我们喜欢以前的那种形式，甚至可以写一个全局的方法，并接受一个闭包，来将 objc_sync_enter 和 objc_sync_exit 封装起来：

```swift
func synchronized(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)再结合 Swift 的尾随闭包的语言特性，这样，使用起来的时候就和 Objective-C 中很像了：
}
```

再结合 Swift 的尾随闭包的语言特性，这样，使用起来的时候就和 Objective-C 中很像了：

```swift
func myMethodLocked(anObj: AnyObject!) {
    synchronized(anObj) {
        // 在括号内 anObj 不会被其他线程改变
    }
}
```