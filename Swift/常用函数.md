# Swift常用函数说明

### map和flatMap

map会遍历array中每一个元素，并对每一个元素执行提供出去的闭包中定义的操作。相当于对array中的所有元素做了一个映射。

示例：
```swift
let numbers = [1, 2, 3, 4]
// func map<T>(_ transform: (Self.Element) throws -> T) rethrows -> [T]
let result = numbers.map { (item: Int) -> Int in
    return item * 2
}
// 简化写法：numbers.map { $0 * 2 } 
print(result) // [2, 4, 6, 8]
```

flatMap和map类似，把上面的map改为flatMap, 其结果是一样的。

看下不同点：

**flagMap降维**

```Swift
let nums = [[1, 2, 3], [4, 5, 6]]
let res = nums.map { $0.map{ $0 + 2 } }
print("get values:") // [[3, 4, 5], [6, 7, 8]]
print(res)
let flatRes = nums.flatMap { $0.map{ $0 + 2 } }
print(flatRes) // [3, 4, 5, 6, 7, 8]
```

为什么？来看一下flatMap的源代码：


[https://github.com/apple/swift/stdlib/public/core/SequenceAlgorithms.swift](https://github.com/apple/swift/stdlib/public/core/SequenceAlgorithms.swift)

```Swift
@inlinable
public func flatMap<SegmentOfResult : Sequence>(_ transform: (Element) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] {
	var result: [SegmentOfResult.Element] = []
	for element in self {
  		result.append(contentsOf: try transform(element))
  		// 新建一个数组，然后把transform后的元素添加到新组里面
	}
	return result
}
```

这就清晰了。
通过上面的代码可以知道，flatMap会让2维变1维，3维变2维，4维变3维... 示例：

```swift
let threeNums = [ [[[1, 2], [1, 2]], [[4, 5], [4, 5]]],
                  [[[1, 2], [1, 2]], [[4, 5], [4, 5]]]
                ]
let nn = threeNums.flatMap {
    $0.map{$0.map {$0.map {$0+2}}}
}
print(nn)  // [[[3, 4], [3, 4]], [[6, 7], [6, 7]], [[3, 4], [3, 4]], [[6, 7], [6, 7]]]
```

对于Array中有nil元互的flatMap, 原来apple也提供了一个flatMap的重载方法，不过后来废弃掉了, 建议使用compactMap，示例：

```swift
let optionalArray: [String?] = ["AA", nil, "BB", "CC"]
var result = optionalArray.compactMap{ $0 } // 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value
print(optionalArray) // [Optional("AA"), nil, Optional("BB"), Optional("CC")]
print(result) // ["AA", "BB", "CC"]
```

