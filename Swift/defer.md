# defer

`defer`的英文原意是 使推迟；使延期； 拖延，推迟   
这个关键字就跟 Java 里的 try-catch-finally 的finally一样，不管 try catch 走哪个分支，它都会在函数真正 return 之前执行, 而且它可以独立于 try catch 存在

示例:  

```swift
import Foundation

var fridgeIsOpen = false
let fridgeContent = ["milk", "eggs", "leftovers"]
 
func fridgeContains(_ food: String) -> Bool {
    fridgeIsOpen = true
    defer {
        fridgeIsOpen = false
    }
    
    let result = fridgeContent.contains(food)
    return result
}

let result: Bool = fridgeContains("banana")
print(result) // false
print(fridgeIsOpen) // false
```

### 用于异常处理

```swift
enum CustomError: Error {
    case myError1
    case myError2
    case myError3
}

// try-catch-defer
func foo() throws {
    defer {
        print("finally")
    }
    do {
        throw CustomError.myError1
    }
    catch CustomError.myError1 {
        print("handle my error 1")
    }
    catch {
        
    }
}

do {
    try foo()
} catch {
    
}
```

### 用于清理工作、回收资源

```swift
// 关闭文件
func closeFileTest() {
    let fileDescriptor: Int32 = open("file path here", O_EVTONLY)
    defer {
        close(fileDescriptor)
    }
    // use fileDescriptor ...
    print(fileDescriptor)
}

// dealloc手动分配空间
func deallocTest() {
    let valuePointer = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    defer {
        valuePointer.deallocate()
    }
    // use valuePointer ...
}

// 加解锁
func lockTest() {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    // do something ...
}
```

### 用于调用completion block

```swift
func foo(completion: () -> Void) {
  defer {
    self.isLoading = false
    completion()
  }
  guard error == nil else { return } 
  // handle success
}

// 调用完成后释放
func foo() {
  defer {
    self.completion = nil
  }
  if (succeed) {
    self.completion(.success(result))
  } else {
    self.completion(.error(error))
  }
}
```

### 用于调用super  

```swift
func override foo() {
  defer {
    super.foo()
  }
  // some preparation before super.foo()...
}
```


### 任意scope都可以有defer 

```swift
var sumOfOdd = 0
for i in 0...10 {
  defer {
    print("Look! It's \(i)")
  }
  if i % 2 == 0 {
    continue
  }
  sumOfOdd += i
}

// continue 或者 break 都不会妨碍 defer 的执行。甚至一个平白无故的 closure 里也可以写 defer
{
  defer { print("bye!") }
  print("hello!")
}
```

### defer不会得到执行的几种情况 

```swift
enum CustomError: Error {
    case myError1
}

func foo() throws {
  do {
    throw CustomError.myError1
    print("impossible")
  }
  defer {
    print("finally")
  }
}

try?foo()

// 不会执行 defer，不会 print 任何东西, 因为至少要执行到 defer 这一行，它才保证后面会触发。同样道理，提前 return 也是一样不行的: 

func foo() {
  guard false else { return }
  defer {
    print("finally")
  }
}
```

### fatal error会阻止defer执行  

fatal error发生时，defer是不会执行的, catch不到 fatal error  

```swift
func throwsFatalError() throws {
    fatalError("it's my fatal error")
}

func foo() {
    defer {
        print("defer here") // 不会执行
    }
    do {
        try throwsFatalError() // 程序直接crash, 不会走到catch和defer
    } catch let err {
        print("get fatal error: \(err)")
    }
}

foo()
```

### 多个defer   

一个 scope 可以有多个 defer，顺序是像栈一样倒着执行的：每遇到一个 defer 就像压进一个栈里，到 scope 结束的时候，后进栈的先执行。如下面的代码，会按 1、2、3、4、5、6 的顺序 print 出来   

```swift
func foo() {
  print("1")
  defer {
    print("6")
  }
  print("2")
  defer {
    print("5")
  }
  print("3")
  defer {
    print("4")
  }
}
```