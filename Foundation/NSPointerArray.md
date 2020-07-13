# NSPointerArray

NSArray、NSSet、NSDictionary一律对其维护的对象强引用, iOS6.0之后, Foundation框架中了以下三个类:  
- NSPointerArray 对应NSArray
- NSHashMap 对应NSSet 
- NSMapTable 对应NSDictionary

这三个类可以做到对其维护的对象弱引用, 这也是它们主要的使用场景    

NSPointerArray和NSArray/NSMutableArray一样，用于有序的插入或移除。不同的是： 

- 可以存储 nil，并且 nil 还参与 count 的计算。
- count 值可以直接设置，如果直接设置count，那么会使用 nil 占位。
- 可以使用 weak 来修饰元素，可以添加所有的指针类型。
- 可以通过 for...in 来进行遍历  

也有一些缺点：

- 操作均基于 index，无法通过 object 来进行操作；
- n无法直接插入 array，或用 array 初始化；
- 查找功能没有 NSArray 强大；
- 没有逆序、排序等 API 提供  

### 初始化    
```Objective-C
- (instancetype)initWithOptions:(NSPointerFunctionsOptions)options;
- (instancetype)initWithPointerFunctions:(NSPointerFunctions *)functions; 

+ (NSPointerArray *)pointerArrayWithOptions:(NSPointerFunctionsOptions)options;
+ (NSPointerArray *)pointerArrayWithPointerFunctions:(NSPointerFunctions *)functions;
```

### 内存管理  
```
NSPointerFunctionsStrongMemory：缺省值，在 CG 和 MRC 下强引用成员
NSPointerFunctionsZeroingWeakMemory：已废弃，在 GC 下，弱引用指针，防止悬挂指针
NSPointerFunctionsMallocMemory 与 NSPointerFunctionsMachVirtualMemory：3 用于 Mach 的虚拟内存管理
NSPointerFunctionsWeakMemory：在 CG 或者 ARC 下，弱引用成员
```

### 特性，用于标明对象判等方式  
```Objective-C
NSPointerFunctionsObjectPersonality：hash、isEqual、对象描述
NSPointerFunctionsOpaquePersonality：pointer 的 hash 、直接判等
NSPointerFunctionsObjectPointerPersonality：pointer 的 hash、直接判等、对象描述
NSPointerFunctionsCStringPersonality：string 的 hash、strcmp 函数、UTF-8 编码方式的描述
NSPointerFunctionsStructPersonality：内存 hash、memcmp 函数
NSPointerFunctionsIntegerPersonality：值的 hash
```

### 使用多个组合进行初始化

```Objective-C
NSPointerFunctionsOptions opt = NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality | NSPointerFunctionsCopyIn;
NSPointerArray *point = [[NSPointerArray alloc]initWithOptions:opt];
```


