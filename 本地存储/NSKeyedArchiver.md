# NSKeyedArchiver

参考: 

- [Matt](https://nshipster.cn/nscoding/)
- [简书](https://www.jianshu.com/p/5ee858da24e8)

NSKeyedArchiver 就是用来存储对象数据到本地，即归档。
NSKeyedUnarchiver，负责从本地存储还原对象数据，即反归档。
同时需要配合 NSCoding 使用，实现序列化以及反序列化

Core Data 和 `NSKeyedArchiver`客观和常见的比较可能是这样的：

|                      |       Core Data        | NSKeyedArchiver |
| :------------------: | :--------------------: | :-------------: |
|   Entity Modeling    |          Yes           |       No        |
|       Querying       |          Yes           |       No        |
|        Speed         |          Fast          |      Slow       |
| Serialization Format | SQLite, XML, or NSData |     NSData      |
|      Migrations      |       Automatic        |     Manual      |
|     Undo Manager     |       Automatic        |     Manual      |

`NSCoding` 是一个简单的协议，有两个方法： `-initWithCoder:` 和 `encodeWithCoder:`。遵循`NSCoding`协议的类可以被序列化和反序列化，这样可以归档到磁盘上或分发到网络上

示例:  

```objective-c
@interface Book : NSObject <NSCoding>
@property NSString *title;
@property NSString *author;
@property NSUInteger pageCount;
@property NSSet *categories;
@property (getter = isAvailable) BOOL available;
@end

@implementation Book

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.title = [decoder decodeObjectForKey:@"title"];
    self.author = [decoder decodeObjectForKey:@"author"];
    self.pageCount = [decoder decodeIntegerForKey:@"pageCount"];
    self.categories = [decoder decodeObjectForKey:@"categories"];
    self.available = [decoder decodeBoolForKey:@"available"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeInteger:self.pageCount forKey:@"pageCount"];
    [encoder encodeObject:self.categories forKey:@"categories"];
    [encoder encodeBool:[self isAvailable] forKey:@"available"];
}

@end
```

NSKeyedArchiver / NSKeyedUnarchiver 使用示例：

```objective-c
// 会把 model 的数据存储到 path 这个路径的文件里
[NSKeyedArchiver archiveRootObject:bookModel toFile:path]; 
// 从文件中直接取出，并生成相应对象
UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
```

如上，NSCoding 主要是样板文件。每个属性用属性名作为key，编码或解码成一个对象或者类型。

### 关于存储后的文件

存储的文件本质是一个 plist 文件，无论文件名是否带有 .plist 后缀，直接打开都是数字。
但使用工具可以查看里面内容，也可以通过写代码读取其中数据。
而在安全性方面，如果我们在设定 Key 时，不跟属性名一样，而是使用随机字符。
这样可以降低文件的可读性，一定程度上也算一种加密。

### 关于嵌套使用

假设 UserModel 有个 CatModel 的对象，那么存储时，是否可以将 CatModel 存储到文件中呢？
其实，只要 CatModel 实现了<NSCoding>，也是可以的。
像 `NSArray`, `NSDictionary` 都已经实现了 <NSCoding> 的子协议 <NSSecureCoding>，可以直接使用。比如，存储多个 Model 到文件中。

但是在控制整个序列化过程中样板文件有时候也是非常有用的东西，它可以保持灵活，可以这样解释：

Migrations: 如果一个数据模型发生变化，如添加，重命名或删除一个字段，这应该与之前序列化的数据保持兼容性。Apple提供了一些参考“Forward and Backward Compatibility for Keyed Archives”.

Archiving non-NSCoding-compatible Classes: 根据面向对象设计原则，对象应该可以被编码和解码成一种序列化的格式。但是如果一个类不是内置遵循NSCoding，你可以后续让这个类遵循NSCoding来达到目的。

[Mantle](https://github.com/Mantle/Mantle)是一个意在减少写NSCoding样板文件的类库。如果你正在寻找更方便使用NSCoding代替Core Data创建model的方法，那Mantle值得一看。 

