# Enum列举

参考: 
- [这里](https://swifter.tips/enum-enumerate/)
- [Here](https://www.jianshu.com/p/9c7a07163e5b)


```Swift
//
//  main.swift
//  列举enum
//
//  Created by liuweizhen on 2019/7/25.
//  Copyright © 2019 liuxing8807@126.com. All rights reserved.
//

import Foundation

protocol EnumAllValuesProtocol {
    static var allValues: [Self] {
        get
    }
}

enum Suit : String, EnumAllValuesProtocol {
    case Spades = "黑桃"
    case Hearts = "红桃"
    case Clubs = "梅花"
    case Diamonds = "方块"
    
    static var allValues: [Suit] {
        return [.Spades, .Hearts, .Clubs, .Diamonds]
    }
}

enum Rank : Int, CustomStringConvertible, EnumAllValuesProtocol {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    var description: String {
        switch self {
        case .Ace:
            return "A"
        case .Jack:
            return "J"
        case .Queen:
            return "Q"
        case .King:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
    
    static var allValues: [Rank] {
        return [.Ace, .Two, .Three,
                .Four, .Five, .Six,
                .Seven, .Eight, .Nine,
                .Ten, .Jack, .Queen, .King]
    }
}

for suit in Suit.allValues {
    for rank in Rank.allValues {
        print("\(suit.rawValue)\(rank)")
    }
}
```

### 嵌套枚举

```swift
enum Area {
    enum DongGuan {
        case NanCheng
        case DongCheng
    }
    
    enum GuangZhou {
        case TianHe
        case CheBei
    }
}

print(Area.DongGuan.DongCheng)
```

### raw value
```swift

    case left = 0
    case right = 1
    case top = 2
    case bottom = 3
}

enum Area: String {
    case DG = "dongguan"
    case GZ = "guangzhou"
    case SZ = "shenzhen"
}

let str: String = Area.DG.rawValue
print(str)
```  

### 关联值  

```swift
enum HttpLine {
    case Success(code: Int, msg: String)
    case BadAcces(code: Int, msg: String)
}

let line = HttpLine.Success(code: 200, msg: "success")
// let fail = HttpLine.BadAcces(code: 404, msg: "fail")
switch line {
    case .Success(let code, let msg):
        print("code: \(code) --> \(msg)")
    case .BadAcces(let code, let msg):
        print("fail: \(code) --> \(msg)")
}
```  

### 方法  

```swift
import Foundation

enum Device {
    case iPad, iPhone, AppleTV, AppleWatch
    
    // 普通方法
    func introduced() -> String {
        switch self {
        case .iPad: return "iPad"
        case .iPhone: return "iPhone"
        case .AppleWatch: return "AppleWatch"
        case .AppleTV: return "AppleTV"
        }
    }
    
    // 静态方法
    static func getFromString(term: String) -> Device? {
        if term == "iWatch" {
            return .AppleWatch
        } else if term == "iPhone" {
            return .iPhone
        }
        // ...
        return nil
    }
}

print(Device.iPhone.introduced())
print(Device.getFromString(term: "iPhone") ?? "Not found")
```

### 属性 

```swift
enum Device {
  case iPad, iPhone
  var year: Int {
    switch self {
    case .iPhone: return 2007
    case .iPad: return 2010
     }
  }
}

print(Device.iPad.year)
```

### 协议  

CustomStringConvertible是一个以打印为目的的自定义格式化输出的类型

```swift
protocol CustomStringConvertible {
  var description: String { get }
}
```  

该协议只有一个要求，即一个只读(getter)类型的字符串(String类型)。我们可以很容易为enum实现这个协议。

```swift
enum Trade :CustomStringConvertible{
    case Buy(stock:String,amount:Int)
    case Sell(stock:String,amount:Int)
    
    var description: String {
        
        switch self {
        case .Buy(_, _):
            return "Buy"
            
        case .Sell(_, _):
            return "Sell"
        }
    }
}

print(Trade.Buy(stock: "003100", amount: 100).description) // Buy
```

### 扩展  

枚举也可以进行扩展。最明显的用例就是将枚举的case和method分离，这样阅读你的代码能够简单快速地消化掉enum内容，紧接着转移到方法定义:

```swift
enum Device {
    case iPad, iPhone, AppleTV, AppleWatch
    
}
extension Device: CustomStringConvertible{
    
    func introduced() -> String {
        
        switch self {
        case .iPad: return "iPad"
        case .iPhone: return "iPhone"
        case .AppleWatch: return "AppleWatch"
        case .AppleTV: return "AppleTV"
        }
    }
 
    var description: String {
        
        switch self {
        case .iPad: return "iPad"
        case .iPhone: return "iPhone"
        case .AppleWatch: return "AppleWatch"
        case .AppleTV: return "AppleTV"
        }
    }
}

print(Device.AppleTV.description) // AppleTV
print(Device.iPhone.introduced()) // iPhone
```

### 泛型 

```swift
enum Rubbish<T> {
    case price(T)
    func getPrice() -> T {
        switch self {
        case .price(let value):
            return value
        }   
    }
}

print(Rubbish<Int>.price(100).getPrice()) // 100
```

