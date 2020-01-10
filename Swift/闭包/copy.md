# copy


闭包Closure在Swift中没有显示Copy的概念。  

参见[Here](https://forums.swift.org/t/copying-a-closure-in-swift/18087)  
The copying mechanism in ObjC is just for getting the block off the stack; once it’s off the stack, “copying” just retains the existing value. That detail is something that Swift hides from you.

```swift
// Closure variables have value semantics. (But are presumably only copy‐on‐write like structures.)

var closure: (Int) -> Void = { print("\($0): I’m still the first closure.") }
closure(1) // 1: I’m still the first closure.

var newVariable = closure
newVariable(2) // 2: I’m still the first closure.

closure = { print("\($0): I’ve been mutated.") }
closure(3) // 3: I’ve been mutated.

newVariable(4) // 4: I’m still the first closure.
```

但是闭包确实维护了其内部的变量，由于闭包是引用类型，  they do hold state and that state isn't copied when you copy the closure itself. Check out this snippet:   

```swift

func giveMeAClosureThatHoldsState() -> ( (Int) -> Int ) {
    var state = 0
    return { difference in
        print("==========> \(difference)")
        state += difference
        return state
    }
}

let closureWithState = giveMeAClosureThatHoldsState()
let closureCopy = closureWithState
let anotherClosureWithState = giveMeAClosureThatHoldsState()
print(closureWithState(1)) // prints 1
print(closureWithState(1)) // prints 2
print(closureCopy(1)) // prints 3
print(anotherClosureWithState(1)) // prints 1
```

打印结果：  

==========> 1
1
==========> 1
2
==========> 1
3
==========> 1
1

