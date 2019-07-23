# Swift基本语法

#### Swift开源源代码
[https://github.com/apple/swift](https://github.com/apple/swift)

#### ?和!

```Swift
var myString: String? // 可能没有值(none)，或有一个类型为String的值
//var myString: Optional<String>
myString = "Hello, Swift!"
if myString != nil {
    print(myString) // Optional("Hello, Swift!")
}
else {
    print("It's null!")
}

import Foundation

//var myString: String! = nil
var myString: String!
print(myString) // none

if myString == nil {
    print("It's none!”)
}
```

#### 函数

Swift 函数参数可以同时有一个局部名称（在函数体内部使用）和一个外部名称（在调用函数时使用\)

```Swift
// 局部参数名
func eat(food: String) -> Void {
    print("eat \(food)")
}

// 此处food作是局部参数名，调用时不可省略
eat(food: "fruit")

// 局部参数名也可作为函数重载的一部分
func eat(food_2: String) -> Void {
    print("\(food_2)")
}
eat(food: "haha")

// 这样可以省略参数名
func drink(_: String) -> Void {
    print("drink water")
}

drink("Water")

// 外部参数名：可以在局部参数名前指定外部参数名，中间以空格分隔，外部参数名用于在函数调用时传递给函数的参数
// 即调用函数时要使用外部参数名
func pow(firstArg a: Int, secondArg b: Int) -> Int {
    var res = a
    for _ in 1..<b {
        res = res * a
    }
    return res
}

// 2的3次方: 8
print(pow(firstArg: 2, secondArg: 3))

// 几种写法：

// 调用时不传参数，空：
func eat() -> Void {
   print("1. eat()")
}
eat()

// 调用时传局部参数：
func eat(food: String) -> Void {
    print("eat: \(food)")
}
eat(food: "2. eat(food: String)")

// 调用时传外部参数：
func eat(FOOD food: String) -> Void {
    print("\(food)")
}
eat(FOOD: "3. eat(FOOD food: String)")

// 调用时不使用参数，但传了值
func eat(_ food: String) -> Void {
    print("\(food)")
}
eat("4. eat(_ food: String) ")
```

#### 可变参数

```Swift
func vari<N>(members: N...) -> Void {
    for i in members {
        print(i)
    }
}

vari(members: 4, 3, 5)
vari(members: "Google", "Baidu", "Runboob")
```

#### 常量，变量及 I/O 参数

默认在函数中定义的参数都是常量参数，这个参数你只可以查询使用，不能改变它的值

```Swift
func eat(_ food: String) -> Void {
    food = "Banana" // Error: Cannot assign to value: 'food' is a 'let' constant
    print("eat: \(food)")
}
```

如果想要声明一个变量参数，可以在参数定义前加 inout 关键字:

```Swift
func eat(_ food: inout String) -> Void {
    food = "Banana"
    print("\(food)")
}

var food = "watermelon"
eat(&food)
```

再示例：

```Swift
func swap(_ a: inout Int, _ b: inout Int) -> Void {
    let temp = a
    a = b
    b = temp
}

var a = 1
var b = 2
swap(&a, &b)
print("a: \(a) -- b: \(b)") // a: 2 -- b: 1
```

#### 函数类型作为参数

```Swift
// 可以定义一个类型为函数的常量或变量，并将适当的函数赋值给它
// 下面我们定义一个函数，然后让一个变量指向这个函数

func sum(a: Int, b: Int) -> Int {
    return a + b
}

var addition: (Int, Int) -> Int = sum
print(addition(1, 2)) // 3

// 上面我们定义一个叫做 addition 的变量，参数与返回值类型均是 Int ，并让这个新变量指向 sum 函数

func sum(a: Int, b: Int) -> Int {
    return a + b
}

func minus(a: Int, b: Int) -> Int {
    return a - b
}

func another(function: (Int, Int) -> Int, a: Int, b: Int) -> Int {
    return function(a, b)
}

print(another(function: sum(a:b:), a: 1, b: 2))
print(another(function: minus(a:b:), a: 1, b: 2))

print(another(function: sum, a: 10, b: 2))
print(another(function: minus, a: 10, b: 2))

var sum_2: (Int, Int) -> Int = sum
var minus_2: (Int, Int) -> Int = minus

print(another(function: sum_2, a: 100, b: 200))
print(another(function: minus_2, a: 100, b: 200))

func mySum(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func mySum(a: Int, b: Int) -> Int {
    return a + b
}

print(another(function: mySum(_:_:), a: 100, b: 200))
print(another(function: mySum(a:b:), a: 100, b: 200))
```

#### 函数类型作为返回值

```Swift
func sum(_ a: Int, _ b: Int) -> Int {
    return a + b
}

func calculate() -> (Int, Int) -> Int {
    return sum(_:_:)
}

print(calculate()(1, 2))
```

#### 函数嵌套

protocol Container {
    associatedtype ItemType
    // 添加一个新元素到容器里
    mutating func append(_ item: ItemType)
    // 获取容器中元素的个数
    var count: Int { get }
    // 通过索引取值
    subscript(i: Int) -> ItemType { get }
}

```Swift
// 加上plusValue，再乘以multiplyValue
// (2 + 5) * 3

func makeCalculate(_ num: Int, _ plusValue: Int) -> (_ multiplyValue: Int) -> Int {
    var value = num + 5;
    func multiply(number: Int) -> Int {
        return value * number
    }
    return multiply
}

let method = makeCalculate(2, 5) // 2 + 5
print(method(3)) // 21

```

#### 字典

```Swift
// key可以是整型或字符串
var someDict:[Int: String] = [1: "One", 2: "Two", 3: "Three"]
print(someDict[1]) // Optional("One") 注：有警告: Expression implicitly coerced from 'String?' to Any
print(someDict[1]!) // One
if let value = someDict[1] {
    print(value)
}

someDict.updateValue("壹", forKey: 1) // [2: "Two", 3: "Three", 1: "壹"]
print(someDict)

移除：
var someDict:[Int:String] = [1:"One", 2:"Two", 3:"Three"]
someDict.removeValue(forKey: 1)
print(someDict[1]) // nil

也可以通过设置值为nil移除

字典遍历：
var someDict:[Int:String] = [1:"One", 2:"Two", 3:"Three"]

for (key, value) in someDict {
    print("字典 key \(key) -  字典 value \(value)")
}
```

#### 闭包

```Swift
// 无参闭包：
let sayHello = {
    print("hello world!")
}

sayHello()

// 带参的闭包：
let divide = {
    (val1: Int, val2: Int) -> Int in
        return val1 / val2
}
let result = divide(200, 20)
print(result)

// 看一个数组排序的示例：
public func sorted(by areInIncreasingOrder: (Element, Element) throws -> Bool) rethrows -> [Element]

let names = ["A", "D", "C", "B", "G"]

直接使用闭包：
var reversed = names.sorted { (s1: String, s2: String) -> Bool in
    return s1 > s2
}
print(names) // ["A", "D", "C", "B", "G"]
print(reversed) // ["G", "D", "C", "B", "A"]

也可以使用函数：
func backwards(s1: String, s2: String) -> Bool {
    return s1 > s2
}
reversed = names.sorted(by: backwards)
print(reversed) // ["G", "D", "C", "B", "A"]

let names = ["A", "D", "C", "B", "G"]

// 可以使用参数名缩写
var reversed = names.sorted(by: {$0 > $1})
print(reversed)
```

尾随闭包：  
尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用。  
其实尾随闭包只是改了一种写法，即如果闭包是函数的最后一个参数，则调用的时候可以放在函数括号之后

```Swift
func calculate(_ a: Int, _ b: Int, _ sum: (Int, Int) -> Int) -> Int {
    return sum(a, b)
}

// 不使用尾随闭包
var result = calculate(20, 30, { (a: Int, b: Int) -> Int in
    return a + b
})

print(result) // 50

// 使用尾随闭包
result = calculate(2, 3) { (a: Int, b: Int) -> Int in
    return a + b
}

print(result) // 5

再示例：
let names = ["T", "A", "B", "S", "D"]

var reversed = names.sorted() { (a: String, b: String) -> Bool in // 这里()可以省略
    return a > b
}
print(reversed)

reversed = names.sorted(by: {
    (a: String, b: String) -> Bool in
        return a > b
})

print(reversed)

再示例：
// 尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用
func test(closure: (String) -> Void) -> Void {
    closure("hello")
}

// 不使用尾随闭包进行函数调用
test(closure: {(a: String) -> Void in
    print(a)
})

// 使用尾随闭包进行函数调用
test() { (a: String) -> Void in
    print(a)
}

// 使用尾随闭包进行函数调用（省略括号）
test { (a: String) -> Void in
    print(a)
}


let names = ["AT", "AE", "D", "S", "BE"]

// 不使用尾随闭包进行函数调用
var reversed_0 = names.sorted(by: {(v1: String, v2: String) -> Bool in
    return v1 < v2
})
print(reversed_0)

// 使用尾随闭包进行函数调用
var reversed_1 = names.sorted() {
    $0 < $1
}
print(reversed_1)

// 使用尾随闭包进行函数调用（省略括号）
var reversed_2 = names.sorted { (v1: String, v2: String) -> Bool in
    return v1 < v2
}
print(reversed_2)
```

#### 闭包捕获值

```Swift
// 闭包可以在其定义的上下文中捕获常量或变量。
// 即使定义这些常量和变量的原域已经不存在，闭包仍然可以在闭包函数体内引用和修改这些值。
// Swift最简单的闭包形式是嵌套函数，也就是定义在其他函数的函数体内的函数。
// 嵌套函数可以捕获其外部函数所有的参数以及定义的常量和变量。
// 函数和闭包都是引用类型
func makeIncrement(a: Int) -> () -> Int {
    var total = 0
    func incrementor() -> Int {
        total += a
        return total
    }
    return incrementor
}

// incrementor实际上捕获并存储了变量total的一个副本，而该副本随着incrementor一同被存储
// 所以我们调用这个函数时会累加

let incrementByTen = makeIncrement(a: 10)

// 返回的值为10
print(incrementByTen()) // 10

// 返回的值为20
print(incrementByTen()) // 20

// 返回的值为30
print(incrementByTen()) // 30

let block = incrementByTen
print(block()) // 40
```

#### 枚举

```Swift
enum DaysofaWeek {
    case Sunday
    case Monday
    case Tuesday
    case Wenesday
    case Thursday
    case Friday
    case Saturday
}

var weekDay = DaysofaWeek.Sunday
weekDay = .Thursday
switch weekDay {
case .Sunday: print("周日")
case .Monday: print("周一")
case .Tuesday: print("周二")
case .Wenesday: print("周三")
case .Thursday: print("周四")
case .Friday: print("周五")
case .Saturday: print("周六")
}

— 枚举原始值 —
// 原始值可以是字符串，字符，或者任何整型值或浮点型值
// 在原始值为整数的枚举时，不需要显式的为每一个成员赋值，Swift会自动为你赋值
enum Month: Int {
    case January = 1,
    Febrary,
    March,
    April,
    May,
    June,
    July,
    August,
    September,
    October,
    November,
    December
}

let m = Month.May.rawValue
print(m) // 5


—  枚举相关值 — 
enum Student {
    case Name(String)
    case Mark(chinese: Int, math: Int, english: Int)
}

var studDetails = Student.Name("Runoob")
var studMarks = Student.Mark(chinese: 98, math: 100, english: 100)

switch studMarks {
case .Name(let studentName):
    print("\(studentName)")
case .Mark(let mark1, let mark2, let mark3):
    print("\(mark1) -- \(mark2) - \(mark3)") // 98 -- 100 - 100
}
```

#### 结构体

注：结构体总是通过被复制的方式在代码中传递，因此它的值是不可修改的

```Swift
struct studentMarks {
    var mark1 = 100
    var mark2 = 78
    var mark3 = 98
}

let marks = studentMarks()
print(marks.mark1)
print(marks.mark2)
print(marks.mark3)

— 示例 —

import Foundation

struct MarksStudent {
    var mark: Int

    init(mark: Int) {
        self.mark = mark
    }

    func addMarkNum(a: Int) -> Int {
        return self.mark + a
    }
}

var a = MarksStudent(mark: 98)
var b = a
b.mark = 97  // b发生变化并不会使用a发生变化，因为结构体是通过被复制的方式传递的
print(a.mark) // 98
print(b.mark) // 97

print(a.addMarkNum(a: 100))
```

结构体实例总是通过值传递来定义你的自定义数据类型（结构体实例是通过值传递而不是通过引用传递）  
按照通用的准则，当符合一条或多条以下条件时，请考虑构建结构体：

结构体的主要目的是用来封装少量相关简单数据值。  
有理由预计一个结构体实例在赋值或传递时，封装的数据将会被拷贝而不是被引用。  
任何在结构体中储存的值类型属性，也将会被拷贝，而不是被引用。  
结构体不需要去继承另一个已存在类型的属性或者行为。

举例来说，以下情境中适合使用结构体：  
几何形状的大小，封装一个width属性和height属性，两者均为Double类型。  
一定范围内的路径，封装一个start属性和length属性，两者均为Int类型。  
三维坐标系内一点，封装x，y和z属性，三者均为Double类型。

#### 属性

Swift 中的属性没有对应的实例变量，属性的后端存储也无法直接访问。这就避免了不同场景下访问方式的困扰，同时也将属性的定义简化成一个语句

```Swift
// 存储属性
var arr0: Int = 100

// 存储属性
// 通过闭包运算赋值
var arr1: [Int] = {
     return [1, 2, 3]
} ()

// 存储属性
// 通过闭包运算赋值
var arr1_1: [Int] = { () -> [Int] in
    return [6, 7, 8]
} ()

// 计算属性，只读，是arr3的简化形式
var arr2: [Int] {
    return [1, 2 ,3]
}

// 计算属性，只读
var arr3: [Int] {
    get {
        return [1, 2, 3]
    }
    set {
        // set方法无效
        print(newValue)
    }
}

// 存储属性可以直接读写赋值。
// 计算属性不能直接对其操作，其本身只起计算作用，没有具体的值
// 2 和 3相同，2是3的简化形式，声明一个计算属性，只读


**延迟存储属性**
延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性。必须将延迟存储属性声明成变量（使用var关键字），因为属性的值在实例构造完成之前可能无法得到。而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延迟属性.

```Swift
class sample {
    lazy var no = number() // `var` 关键字是必须的
}

class number {
    var name = "Runoob Swift 教程"
}

var firstsample = sample()
print(firstsample.no.name)
```

**属性观察器**
有一些属性不需要属性观察器：
- 延迟存储属性
- 无法重载的计算属性（因为可以通过setter直接监控和响应值的变化）

观察器方法:
- willSet在设置新的值之前调用
- didSet在新的值被设置之后立即调用
- 注：willSet和didSet观察器在属性初始化过程中不会被调用

```swift
class Samplepgm {
    var counter: Int = 0 {
        willSet(newTotal) {
            print("willSet：\(newTotal)")
        }
        didSet {
            if counter > oldValue {
                print("did plus：\(counter - oldValue)")
            }
        }
    }
}

@IBAction func click(_ sender: Any) {
    c.counter = 100;
    c.counter = 200;
}
```

**类属性**
使用关键字 static 来定义值类型的类型属性，关键字 class 来为类定义类型属性。
即，在结构体或枚举里，使用static，在class中使用class. 示例：

```swift
struct Rectangle {
    static var length = 100.0
}

enum WeekDay {
    static var currentDay = "Monday"
}

class Person {
    static var sex: Int {
        return 1
    }
    // static var sex = "1" // 如果在class中是存储属性，不能使用class, 要使用static
}
```

#### 初始化

```Swift
http://huizhao.win/2016/11/13/swift-init/

swift的初始化方法，如果是继承于其他类，需要加关键字override，但可以不实现super.init方法，编译器会自动添加。
在初始化方法中要求所有的成员变量都已被正确赋值，示例：

class BlogInit: NSObject {
    let param: String
    override init() {
        self.param = "da liu"
        // super.init() 可不写，编译器自动生成
    }
}

对于需要修改父类中成员变量值的情况，我们需要在调用 super.init 之后再进行修改

class Cat: NSObject {
    var name: String

    override init() {
        name = "cat"
    }
}

class Tiger : Cat {
    let power: Int

    override init() {
        power = 10
        super.init()
        name = "tiger"
    }
}
```

因此 Swift 中类的初始化顺序可以总结如下：

1. 初始化自己的成员变量，必须；power = 10
2. 调用父类初始化方法，如无需第三步，则这一步也可省略； super.init\(\)
3. 修改父类成员变量，可选。name = “tiger”

补充:  
使用 let 声明的常量是可以在初始化方法中进行赋值的，这是编译器所允许的，因为 Swift 中的 init 方法只会被调用一次，这与 Objective-C 不同；

#### 初始化init

![](images/2.png)

designated intializers  
convenience initializers

在 Apple 的官方文档中讲到，Swift 定义了两种类初始化器类型，用来保证所有成员属性能够获得一个初始化值，  
 即 designated initializers 和 convenience initializers  
 Designated initializers are the primary initializers for a class. A designated initializer fully initializes all properties introduced by that class and calls an appropriate superclass initializer to continue the initialization process up the superclass chain.

primary initializers：designated initializers 是一个类的主初始化器，理论上来说是一个类初始化的必经之路（注：不同的初始化路径可能调用不同的 designated initializers）  
fully initializes all properties：这点很明确，必须在 designated initializers 中完成所有成员属性的初始化  
calls an appropriate superclass initializer：需要调用合适的父类初始化器完成初始化，不能随意调用

UIView的两个designated initializers:

```Swift
public init(frame: CGRect)
public init?(coder aDecoder: NSCoder)

class CustomView: UIView {
    let param: Int

    // Designated initializer
    override init(frame: CGRect) {
        self.param = 1
        super.init(frame: frame)
    }

    // Required initializer
    // 'required' initializer 'init(coder:)' must be provided by subclass of 'UIView'
    required init?(coder aDecoder: NSCoder) {
        // fatalError("init(coder:) has not been implemented")
        self.param = 1
        super.init(coder: aDecoder)
    }

    // Convenience initializer
    convenience init(param: Int, frame: CGRect) {
        // self.param = param // 'let' property 'param' may not be initialized directly; use "self.init(...)" or "self = ..." instead
        self.init(frame: frame)
    }
}
```

#### 可失败初始化器

可失败初始化器（Failable Initializers），即可以返回 nil 的初始化方法  
就是将初始化返回值变成 optional value（在 init 后面加上 ?），并在不满足初始化条件的地方 return nil，这样，我们通过调用处判断是否有值即可知道是否初始化成功

```Swift
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty {
            return nil
        }
        self.name = name
    }
}

class Car: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}
```

#### 逐一成员构造器

如果结构体对所有存储型属性提供了默认值且自身没有提供定制的构造器，它们能自动获得一个逐一成员构造器  
结构体 Rectangle 自动获得了一个逐一成员构造器 init\(length:breadth:\)

![](images/3.png)

#### Swift中的子类仅在确定和安全的情况下被继承

```Swift
class mainClass {
    var no1: Int
    init(no1: Int) {
        self.no1 = no1
    }
}

class SubClass: mainClass {
    var no2: Int
    init(no1: Int, no2: Int) {
        self.no2 = no2
        super.init(no1: no1)
    }
}

var sub: SubClass = SubClass(no1: 10, no2: 20)
sub = SubClass(no1: 10) // Missing argument for parameter 'no2' in call
```

上面的父类的构造器Init没有被继承，因为假始被SubClass继承，则no2就可能没有被初始化，因此，这是“不安全的”

下面的示例可以：

```Swift
class mainClass: NSObject {
    var no1: Int
    init(no1: Int) {
        self.no1 = no1
    }
}

class SubClass: mainClass {
}

var sub = SubClass(no1: 10) // OK
```

另外需要注意的是：Swift中当重载父类指定的构造器时，需要写override

#### 元组

```Swift
// 不需要的元素用 _ 标记
let (name, age, _) = ("明明", 10, "男")
print(name, age)

// 通过下标访问特定的元素
let student = ("明明", 10, "男")
print(student.0, student.1, student.2)

// 通过指名名字访问元素
let bobo = (name:"波波",age:"24")
print(bobo.name, bobo.age)
```

#### mutating

Swift 语言中结构体和枚举是值类型。一般情况下，值类型的属性不能在它的实例方法中被修改。  
如果你确实需要在某个具体的方法中修改结构体或者枚举的属性，你可以选择变异\(mutating\)这个方法，然后方法就可以从方法内部改变它的属性；

```Swift
struct area {
    var length = 1
    var breadth = 1

    func area() -> Int {
        return length * breadth
    }

    func resetValue(length: Int, breadth: Int) -> Int {
        self.length = length // Cannot assign to property: 'self' is immutable
    }
}

struct area {
    var length = 1
    var breadth = 1

    func area() -> Int {
        return length * breadth
    }

    mutating func resetValue(length: Int, breadth: Int) -> Int {
        self.length = length // ok
        ...
    }
}
```

#### static方法

声明结构体和枚举的类型方法，在方法的func关键字之前加上关键字static。类可能会用关键字class来允许子类重写父类的实现方法。

```Swift
class Animal {
    class func eat() -> Void {
        print("animal eat")
    }
}

class Cat: Animal {
    override static func eat() -> Void {
        print("cat eat")
    }
}

Animal.eat()
Cat.eat()
```

#### 下标脚本

```Swift
subscript(index: Int) -> Int {
    get {
        // 用于下标脚本值的声明
    }
    set(newValue) {
        // 执行赋值操作
    }
}

struct SubExample {
    let num: Int = 100

    subscript(i: Int) -> Int {
        return num / i
    }
}

let division = SubExample()
print("100 除以 9 等于 \(division[9])")
print("100 除以 2 等于 \(division[2])")
print("100 除以 3 等于 \(division[3])")
print("100 除以 5 等于 \(division[5])")
print("100 除以 7 等于 \(division[7])")
```

#### 可选链

可选链（Optional Chaining）是一种可以请求和调用属性、方法和子脚本的过程，用于请求或调用的目标可能为nil
可选链返回两个值：
- 如果目标有值，调用就会成功，返回该值
- 如果目标为nil，调用将返回nil
多次请求或调用可以被链接成一个链，如果任意一个节点为nil将导致整条链失效

```swift

// Person::Residence::Room&Address
class Person {
    var residence: Residence?
}

class Residence {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    var heights = [Int]()
    subscript(i: Int) -> Room {
        return rooms[i]
    }
    func printNumberOfRooms() -> Void {
        print("房间数量：\(numberOfRooms)")
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) {
        self.name = name
    }
}

class Address {
    var street: String?
    var buildingName: String?
    var buildingNumber: String?
    func buildingIdentifier() -> String? {
        if buildingName != nil {
            return buildingName
        }
        else if buildingNumber != nil {
            return buildingNumber
        }
        else {
            return nil
        }
    }
}

@IBAction func click(_ sender: Any) {
    let john = Person()
    if john.residence?.printNumberOfRooms() != nil { // 如果方法调用成功，返回为Void, 不是nil, 如果中间出错错误，返回为nil
        print("ok")
    }
    else {
        print("error")
    }
}
```

#### 内存管理
swift使用自动引用计数，Swift 提供了两种办法用来解决循环强引用问题：

- weak 弱引用: 对于生命周期中会变为nil的实例使用弱引用
- unowned 无主引用: 对于初始化赋值后再也不会被赋值为nil的实例，使用无主引用

**闭包引起的循环强引用**
循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了实例, 比如self.a = 闭包w, 而闭w中又"捕获"了self

示例：

```swift

class HTMLElement {
    let name: String
    let text: String?

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        }
        else {
            return "<\(self.name) />"
        }
    }

    deinit {
        print("\(name) 析构函数被调用")
    }
}

@IBAction func click(_ sender: Any) {
    var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello world!")
    print(paragraph!.asHTML())

    paragraph = nil
}
```

#### 类型转换

- is   if a is Cat: 如果a是Cat 
- as?  if let cat = a as? Cat: 如果可以把a转换为Cat类型
- as!  let cat = a as! Cat: 强制把a转换为Cat类型

**Any和AnyObject**
Swift为不确定类型提供了两种特殊类型别名：
- AnyObject可以代表任何class类型的实例。
- Any可以表示任何类型，包括方法类型（function types)

#### 协议

如果协议里有构造器方法，则实现类里的实现方法必须使用required关键字。
使用required修饰符可以保证：所有的遵循该协议的子类，同样能为构造器规定提供一个显式的实现或继承实现。

如果一个子类重写了父类的指定构造器，并且该构造器遵循了某个协议的规定，那么该构造器的实现需要被同时标示required和override修饰符:

```swift
protocol TcpProtocol {
    init(no1: Int)
}

class mainClass {
    var no1: Int
    init(no1:Int) {
        self.no1 = no1
    }
}

class subClass: mainClass, TcpProtocol {
    var no2: Int
    init(no1: Int, no2: Int) {
        self.no2 = no2
        super.init(no1: no1)
    }
    // 因为遵循协议，需要加上"required"; 因为继承自父类，需要加上"override", 因为调用了self.init, 因此需要加"convenience"
    required override convenience init(no1: Int) { // Designated initializer for 'subClass' cannot delegate (with 'self.init'); did you mean this to be a convenience initializer?
        self.init(no1: no1, no2: 0)
    }
}
```
**专属协议**
可以在协议的继承列表中,通过添加class关键字,限制协议只能适配到类（class）类型，
示例：

```swift
// 指定AnimalProtocol只能被Animal或Animal的子类遵守
protocol AnimalProtocol: Animal {
    func drink() -> Void
}

class Animal {
    func eat() -> Void {
        print("Animal eat")
    }
}

class Cat : Animal, AnimalProtocol {
    func drink() {
        print("cat drink")
    }
}

class Fruit: AnimalProtocol {
    // Error: 'AnimalProtocol' requires that 'Fruit' inherit from 'Animal'
}
```

**协议合成**

```Swift
protocol Stname {
    var name: String { get }
}

protocol Stage {
    var age: Int { get }
}

struct Person: Stname, Stage {
    var name: String
    var age: Int
}

func show(celebrator: Stname & Stage) {
    print("\(celebrator.name) is \(celebrator.age) years old")
}

let studname = Person(name: "Priya", age: 21)
print(studname)

let stud = Person(name: "Rehan", age: 29)
print(stud)

let student = Person(name: "Roshan", age: 19)
print(student)
```

#### 泛型

先来回顾一下可变参的写法：

```Swift
// vfunc swapTwoValues<T>(_ a: inout T, _ b: inout T)
func vari<N>(members: N...){
    for i in members {
        print(i)
    }
}
vari(members: 4,3,5)
vari(members: 4.5, 3.1, 5.6)
vari(members: "Google", "Baidu", "Runoob")
```

泛型写法类似，示例：

```Swift
// 定义一个交换两个变量的函数
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}
 
var numb1 = 100
var numb2 = 200
 
print("交换前数据:  \(numb1) 和 \(numb2)")
swapTwoValues(&numb1, &numb2)
print("交换后数据: \(numb1) 和 \(numb2)")
 
var str1 = "A"
var str2 = "B"
 
print("交换前数据:  \(str1) 和 \(str2)")
swapTwoValues(&str1, &str2)
print("交换后数据: \(str1) 和 \(str2)")
```

**扩展泛型类型**
示例：

```Swift

struct Stack<T> {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    mutating func pop() -> T? {
        if items.isEmpty {
            return nil
        }
        return items.removeLast()
    }
}

extension Stack {
    var topItem: T? {
        return items.isEmpty ? nil : items[items.count-1]
    }
}

var stack = Stack<String>()
stack.push("Google")
stack.push("Baidu")
stack.push("Ali")

if let topItem = stack.topItem {
    print("栈顶元素：\(topItem)")
}
```

**类型约束**
```Swift
func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
    // 这里是泛型函数的函数体部分
}
```

上面这个函数有两个类型参数。第一个类型参数 T，有一个要求 T 必须是 SomeClass 子类的类型约束；第二个类型参数 U，有一个要求 U 必须符合 SomeProtocol 协议的类型约束。

**关联类associatedtype**

Swift 中使用 associatedtype 关键字来表示泛型的关联类型

```Swift

struct Stack<T>: Container {
    var items = [T]()
    mutating func push(_ item: T) {
        items.append(item)
    }
    mutating func pop() -> T? {
        if items.isEmpty {
            return nil
        }
        return items.removeLast()
    }

    // Container 协议的实现部分
    mutating func append(_ item: T) { // 此处T可替换为：Stack<T>.ItemType
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(i: Int) -> T {
        return items[i]
    }
}

extension Stack {
    var topItem: T? {
        return items.isEmpty ? nil : items[items.count-1]
    }
}

override func viewDidLoad() {
    super.viewDidLoad()
    
    var tos = Stack<String>()
    tos.push("google")
    tos.push("runoob")
    tos.push("taobao")
    // 元素列表
    print(tos.items)
    // 元素个数
    print( tos.count)
}
```

**Where约束**

可以在参数列表中通过where语句定义参数的约束


#### Swift常见关键字
**inout**
inout关键字用一句话概括：将值类型的对象用引用的方式传递。
我们经常说值类型和引用类型实际上就是指对象的传递方式分别是 按值传递 和 按址传递

```swift
func test(){
    var a:Int = 5
    handle(a:&a)   //  注意这里使用了取址操作
    print(a)    // 6
}

func handle(a:  inout Int){
    print(a)
    a = a + 1     //如果没有inout修饰的话，这句代码将会报错，主要意思是不能改变一个let修饰的常量。
}
```

**guard**
if-else和guard-else很类似，只是guard和else必须成对出现，而且else中必须return, 因此guard-else常用来表示，如果...继续，否则返回
比如：

```swift
let a: Int = 100
if (a % 20 == 0 && a % 5 == 0) {
    print("hello")
}
else {
    return
}

相当于：

guard a % 20 == 0 && a % 5 == 0 else { return }
print("hello")
```

#### Swift对象类型易混淆点

**类和类的类型对象.self**

示例：
```
class A {
    static func test() {
        if A == self { // 编译器报错：... Use '.self' to reference the type object ...
            print("A == self") // 把上面语句改成 A.self == self, 此句被打印
        }
    }
}

```

我们知道，在类方法中self, 代表类本身，在实例方法中self代表对象本身。
这里`A`不可以和`self`比较，编译器提示：`Use '.self'` to reference the type object
也就是说：`A`是类，而`A.self`是类A的类型对象。其实可以理解成A的“元类型MetaType”。

```swift
print(Int.self) // Int
print(String.self) // String
let student: String = "hello"
print(student.self) // hello
```

XXX.self：如果XXX是一个Class, 即类，则XXX.self代表这个类的类型对象，如果XXX是一个对象，则XXX.self就是对象本身(一般不使用XXX是对象的情况)。

可以这样判断某一个对象是否属于某一个类, a是否属于A类：

if type(of: a) == A.self {
    ...
}

不过，也可以使用is表达式，直接使用Class本身，而不是Class的type对象：

if a is A {
    ...
}

**元类型**
元类型，Metatype, 参见：
[SwiftRock](https://swiftrocks.com/whats-type-and-self-swift-metatypes.html)




**type(of:)**


示例：

```Swift
class A {
    // 类方法
    class func classMethod() {
        // type对应OC中的Class，是类类型
        let type1 = type(of: self)
        print("1. type(of: self) ==> ", type1) // A.Type
        let type2 = self // 在类方法中，self就代表Type，即Class
        print("2. self ==> ", type2) // A
        let type3 = A.self
        print("3. A.self ==> ", type3) // A
        if type1 == type3 {
            print("type(of: self) == A.self")
        }
        if type1 == type2 {
            print("type(of: self) == self")
        }
        if type2 == type3 { // 相等
            print("self == A.self")
        }
    }

    func instanceMethod() {
        let type1 = type(of: self) // self所属的Class
        print("1. type(of: self) ==> ", type1) // A
        let type2 = self
        print("2. self ==> ", type2) // type和_self.A
        let type3 = A.self
        print("3. A.self ==> ", type3) // A
        if type1 == type3 {
            // 相同
            print("type(of: self) == A.self")
        }
        // Binary operator '==' cannot be applied to operands of type 'A.Type' and A
        // if type1 == type2 {
        //    print("type(of: self) == self")
        // }

        // if type2 == type3 { // 相等
        //     print("self == A.self")
        // }
    }
}
```

打印结果显示：
```
类方法中：
1. type(of: self) ==>  A.Type
2. self ==>  A
3. A.self ==>  A
self == A.self

实例方法中：
1. type(of: self) ==>  A
2. self ==>  type和_self.A
3. A.self ==>  A
type(of: self) == A.self
```

解释：
在类方法中：`type(of: self) ==> A.Type` 这里的
