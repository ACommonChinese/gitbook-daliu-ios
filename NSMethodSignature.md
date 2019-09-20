# NSMethodSignature

NSMethodSignature即方法签名，属Foundation, 是runtime的一部分。

> A record of the type information for the return value and parameters of a method.

NSMethodSignature对方法的返回值类型和参数类型进行记录，保存方法的信息。

在iOS中一般可使用NSObject的`methodSignatureForSelector:`实例方法创建NSMethodSignature对象，在MacOS 10.5以后也可以使用`signatureWithObjCTypes:`方法，系统可以通过NSMethodSignature对象创建NSInvocation对象，所以一般`methodSignatureForSelector:`和`forwardInvocation:`会同时实现，系统通过`methodSignatureForSelector`获取NSMethodSignature对象并创建NSInvocation对象，然后把这个对象传递给`forwardInvocation:`方法.

### Type Encodings

为了分发对象, NSInvocation object is encoded using the information in the NSMethodSignature object and sent to the real object represented by the receiver of the message.

An `NSMethodSignature` object is initialized with an array of characters representing the string encoding of return and argument types for a method. You can get the string encoding of a particular type using the `@encode()` compiler directive. Because string encodings are implementation-specific, you should not hard-code these values.

A method signature consists of one or more characters for the method return type, followed by the string encodings of the implicit arguments `self` and `_cmd`, followed by zero or more explicit arguments. You can determine the string encoding and the length of a return type using [`methodReturnType`](dash-apple-api://load?request_key=hcLJKSpwpo#dash_1519667) and [`methodReturnLength`](dash-apple-api://load?request_key=hcLJKSpwpo#dash_1519666) properties. You can access arguments individually using the [`getArgumentTypeAtIndex:`](dash-apple-api://load?request_key=hcLJKSpwpo#dash_1519660) method and [`numberOfArguments`](dash-apple-api://load?request_key=hcLJKSpwpo#dash_1519662) property.

For example, the `NSString` instance method [`containsString:`](dash-apple-api://load?topic_id=1414563&language=occ) has a method signature with the following arguments:

1. `@encode(BOOL)` (`c`) for the return type
2. `@encode(id)` (`@`) for the receiver (`self`)
3. `@encode(SEL)` (`:`) for the selector (`_cmd`)
4. `@encode(NSString *)` (`@`) for the first explicit argument

上面这一堆主要说类型编码，为了方便分发消息给对象，NSInvocation使用返回值类型和参数类型进行了类型编码，比如返回值类型是BOOL, 使用类型编码成了`c`, 类型编码可以参见[这里](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100)

| Code               | Meaning                                                      |
| :----------------- | :----------------------------------------------------------- |
| `c`                | A `char`                                                     |
| `i`                | An `int`                                                     |
| `s`                | A `short`                                                    |
| `l`                | A `long``l` is treated as a 32-bit quantity on 64-bit programs. |
| `q`                | A `long long`                                                |
| `C`                | An `unsigned char`                                           |
| `I`                | An `unsigned int`                                            |
| `S`                | An `unsigned short`                                          |
| `L`                | An `unsigned long`                                           |
| `Q`                | An `unsigned long long`                                      |
| `f`                | A `float`                                                    |
| `d`                | A `double`                                                   |
| `B`                | A C++ `bool` or a C99 `_Bool`                                |
| `v`                | A `void`                                                     |
| `*`                | A character string (`char *`)                                |
| `@`                | An object (whether statically typed or typed `id`)           |
| `#`                | A class object (`Class`)                                     |
| `:`                | A method selector (`SEL`)                                    |
| [*array type*]     | An array                                                     |
| {*name=type...*}   | A structure                                                  |
| (*name*=*type...*) | A union                                                      |
| `b`num             | A bit field of *num* bits                                    |
| `^`type            | A pointer to *type*                                          |
| `?`                | An unknown type (among other things, this code is used for function pointers) |

 Objective-C method encodings:

| Code | Meaning  |
| :--- | :------- |
| `r`  | `const`  |
| `n`  | `in`     |
| `N`  | `inout`  |
| `o`  | `out`    |
| `O`  | `bycopy` |
| `R`  | `byref`  |
| `V`  | `oneway` |

