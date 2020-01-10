# typealias

```swift
/// public typealias AnyClass = AnyObject.Type
public typealias MyCallback = (AnyObject?) -> Void
public typealias MyCallback2 = (String, String) -> String

typealias CompletionBlock = (NSString?) -> Void
var completion: CompletionBlock = { reason in
    print(reason!)
}
completion("say hello")
```

The [syntax for function types](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Functions.html) is `(in) -> out`.

```swift
// typealias CompletionBlock = (result: NSString?, error: NSString?) -> Void
// Function types cannot have argument labels; use '_' before 'error'

typealias CompletionBlock = (_ result: NSString, _ error: NSString) -> Void

var completion: CompletionBlock = { result, error in
    print("result: \(result)")
    print("error: \(error)")
}
completion("this is result", "this is error")
```

