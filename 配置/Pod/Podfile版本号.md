# Podfile版本号

```ruby
pod 'AFNetworking',  // 不指定版本号
pod 'AFNetworking', '1.0' // 版本只能为1.0
pod 'AFNetworking', '~> 1.0' // 版本号可以是1.0，版本可取范围：[1.0, 2)


Besides no version, or a specific one, it is also possible touse logical operators:

'> 0.1'    Any version higher than 0.1         0.1以上
'>= 0.1'   Version 0.1 and any higher version  0.1以上，包括0.1
'< 0.1'    Any version lower than 0.1          0.1以下
'<= 0.1'   Version 0.1 and any lower version   0.1以下，包括0.1
In addition to the logic operators CocoaPods has an optimisicoperator ~>:

'~> 0.1.2' Version 0.1.2 and the versions up to 0.2, not including 0.2 and higher  0.2以下(不含0.2)，0.1.2以上（含0.1.2）
'~> 0.1' Version 0.1 and the versions up to 1.0, not including 1.0 and higher      1.0以下(不含1.0)，0.1以上（含0.1）
'~> 0' Version 0 and higher, this is basically the same as not having it.          0和以上，等于没有此约束
```

