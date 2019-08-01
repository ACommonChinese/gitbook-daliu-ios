# 多重optional

先来看一下Optional是什么东西

```Swift
let name: String? = "da liu"
print(name) // Optional("da liu")
print(name!) // da liu
```

Optional其实是一个枚举:

```Swift
public enum Optional<Wrapped> : ExpressibleByNilLiteral {
    /// 缺省值
    ///
    /// 在代码中，缺省值常赋为 `nil`
    case none

    /// The presence of a value, stored as `Wrapped`.
    case some(Wrapped)

    ...
}
```

这个枚举中一共有两个case，一个是none, 一个是some(Wrapped), 假如一个变量的值为nil, 则它一定等于Optional.none:

```Swift
let name: String? = nil
if Optional.none == nil && Optional.none == name {
    print("Optional.none == nil") // 条件成立，打印
}
```

也就是说，由于Optional的本质是一个含有两个case值的枚举，那么Optional的变量要么是nil, 要么是som(Wrapped)。这个Wrapped是枚举的相关值，就是实际的值，我们可以把Optional想像成一个箱子，打开这个箱子后，里面可能什么都没有, none, 也可能有我们需要的东西，这个东西就是some(Wrapped), 怎么打开箱子？使用`!`,  我们可以打个断点查看一下上面示例中name的本质:

```
(lldb) fr v -R name
(Swift.Optional<Swift.String>) name = none {
  some = {
    _guts = {
      _object = {
        _countAndFlagsBits = {
          _value = 0
        }
        _object = 0x0000000000000000
      }
    }
  }
}
```

分析：

由于`let name: String? = nil`，有`?`修饰，那么name是一个Optional, 既然是Optional, 必是Optional中两个case中的一个，由于它是nil, 于是name就是Optional.none, 即name = none { ... }, 如果我们写为`let name: String? = "da liu"`, 再查看name:

```Swift
(lldb) fr v -R name
(Swift.Optional<Swift.String>) name = some {
  some = {
    _guts = {
      _object = {
        _countAndFlagsBits = {
          _value = 129095646077284
        }
        _object = 0xe600000000000000
      }
    }
  }
}
```

由于name不是nil, 那么name就是some(Wrapped)，这个Wrapped就是Swift封装的和"daliu"关联的值。

上面提到，把Optional想像成箱子，箱子中可以是none, 可以是some(Wrapped), 那这个some(Wrapped)中也可以有另外的箱子，即箱子中含有箱子，这就是多重Optional:

```Swift
let aNil: String? = nil
let anotherNil: String?? = aNil
let literalNil: String?? = nil
if let a = anotherNil { // 条件成立，打印
    print("anotherNil: \(String(describing: a))")
}

if let b = literalNil { // 条件不成立
    print("literalNil: \(String(describing: b))")
}
```

一个条件成立，一个不成立，通过lldb打印分析即知：

```
(lldb) fr v -R anotherNil
(Swift.Optional<Swift.Optional<Swift.String>>) anotherNil = some {
  some = none {
    some = {
      _guts = {
        _object = {
          _countAndFlagsBits = {
            _value = 0
          }
          _object = 0x0000000000000000
        }
      }
    }
  }
}


(lldb) fr v -R literalNil
(Swift.Optional<Swift.Optional<Swift.String>>) literalNil = none {
  some = some {
    some = {
      _guts = {
        _object = {
          _countAndFlagsBits = {
            _value = 0
          }
          _object = 0x0000000000000001
        }
      }
    }
  }
}
```

即：

```
anotherNil和literalNil都是： Optional<Optional<String>>
分析anotherNil => Optional<Optional<String>> => Optional<aNil> => Optional<nil>
分析literalNil => Optional<Optional<String>> => Optional<nil>
当if let a = anotherNil时，a = Optional<aNil>是有值的，因此条件成立，而
if let b = literalNil时，b = Optional<nil>，直接是nil, 即none了，因此条件不成立
```

参考：

- [swifter.tips](https://swifter.tips/multiple-optional/)