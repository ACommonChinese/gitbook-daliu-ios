# NSScanner

[Apple NSSCanner](https://developer.apple.com/documentation/foundation/nsscanner?language=objc)
[here](https://nshipster.com/nsscanner/)
[raywenderlich.com](https://www.raywenderlich.com/1039-scanner-tutorial-for-macos#toc-anchor-008)

```
A string parser that scans for substrings or characters in a character set, and for numeric values from decimal, hexadecimal, and floating-point representations.
```

NSScanner的主要作用是字符串解析器，可用于把NSString解析成数字或字符串值. NSScanner类是一个类簇的抽象父类,该类簇为一个从NSString对象扫描值的对象提供了程序接口。当你从NSScanner对象获取内容的时候，它会从头到尾遍历字符串(string)。
在 NSScanner 对象扫描字符串的时候，你可以通过设置属性`charactersToBeSkipped`忽略某些字符。在扫描字符串之前，那些位于`忽略字符集`中的字符将会被跳过。默认的忽略字符是`空格`和`回车字符`.

可以通过`[[scanner string] substringFromIndex:[scanner scanLocation]]`获取未扫描的字符串。

NSScanner的配置属性：

```Objective-C
@property NSUInteger scanLocation  // 下次扫描开始的位置，如果该值超出了string的区域，将会引起NSRangeException,该属性在发生错误后重新扫描时非常有用
@property BOOL caseSensitive // 是否区分字符串中大小写的标志。默认为NO，注意：该设置不会应用到被跳过的字符集
@property(copy) NSCharacterSet *charactersToBeSkipped // 在扫描时被跳过的字符集，默认是空白格和回车键, 被跳过的字符是一个唯一值，scanner不会将忽略大小写的功能应用于它，也不会用这些字符做一些组合，如果在扫描字符换的时候你想忽略全部的元音字符，就要这么做（比如：将字符集设置成“AEIOUaeiou”}
@property(retain) id locale // scanner 的locale对它从字符串中区分数值产生影响，它通过locale的十进制分隔符区分浮点型数据的整数和小数部分
```

先看一个示例:

```Objective-C
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *str = @"123 hello";
        NSScanner *scanner = [NSScanner scannerWithString:str];
        NSString *target1 = nil;
        [scanner scanString:@"hello" intoString:&target1];
        NSLog(@"1 %@ - %@", target1, [scanner isAtEnd]?@"结束":@"未结束"); // 1 (null) - 未结束
        NSString *target2 = nil;
        [scanner scanString:@"123" intoString:&target2];
        NSLog(@"2 %@ - %@", target1, [scanner isAtEnd]?@"结束":@"未结束"); // 2 (null) - 未结束
        NSString *target3 = nil;
        [scanner scanString:@"123" intoString:&target3];
        NSLog(@"3 %@ - %@", target1, [scanner isAtEnd]?@"结束":@"未结束");; // 3 (null) - 未结束
        NSString *target4 = nil;
        [scanner scanString:@"hello" intoString:&target4];
        NSLog(@"4 %@ - %@", target1, [scanner isAtEnd]?@"结束":@"未结束");; // 4 (null) - 结束
        NSString *target5 = nil;
        [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"123"] intoString:&target5];
        NSLog(@"5 %@ - %@", target1, [scanner isAtEnd]?@"结束":@"未结束"); // 5 (null) - 结束
    }
    return 0;
}
```


常用API说明：

```Objective-C
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)scanSet   intoString:(NSString * _Nullable *)stringValue;
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)stopSet    intoString:(NSString * _Nullable *)stringValue;
- (BOOL)scanString:(NSString *)string  intoString:(NSString * _Nullable *)stringValue;
- (BOOL)scanUpToString:(NSString *)stopString   intoString:(NSString * _Nullable *)stringValue;
- (BOOL)scanDecimal:(NSDecimal *)decimalValue;
- (BOOL)scanDouble:(double *)doubleValue;
- (BOOL)scanFloat:(float *)floatValue;
- (BOOL)scanHexDouble:(double *)result;
- (BOOL)scanHexFloat:(float *)result;
- (BOOL)scanHexInt:(unsigned int *)intValue;
- (BOOL)scanHexLongLong:(unsigned long long *)result;
- (BOOL)scanInt:(int *)intValue;
- (BOOL)scanInteger:(NSInteger *)value;
- (BOOL)scanUnsignedLongLong:(unsigned long long *)unsignedLongLongValue;
@property(getter=isAtEnd, readonly) BOOL atEnd;
```

**`scanCharactersFromSet:intoString:`**
扫描字符串中和NSCharacterSet字符集中匹配的字符，是按字符单个匹配的，例如，NSCharacterSet字符集为@"test123Dmo"，scanner字符串为 @"  123test12Demotest"，那么字符串中所有的字符都在字符集中，所以指针指向的地址存储的内容为"123test12Demotest"

**`scanUpToCharactersFromSet:intoString`**
扫描字符串直到遇到NSCharacterSet字符集的字符时停止，指针指向的地址存储的内容为遇到跳过字符集字符之前的内容

**`scanString:intoString:`**
从当前的扫描位置开始扫描，判断扫描字符串是否从当前位置能扫描到和传入字符串相同的一串字符，如果能扫描到就返回YES,指针指向的地址存储的就是这段字符串的内容。例如scanner的string内容为123abc678,传入的字符串内容为abc，如果当前的扫描位置为0，那么扫描不到，但是如果将扫描位置设置成3，就可以扫描到了

**`scanUpToString:intoString:`**
从当前的扫描位置开始扫描，扫描到和传入的字符串相同字符串时，停止，指针指向的地址存储的是遇到传入字符串之前的内容。例如scanner的string内容为123abc678,传入的字符串内容为abc，存储的内容为123

**`scanDouble`**
扫描双精度浮点型字符，溢出和非溢出都被认为合法的浮点型数据。在溢出的情况下scanner将会跳过所有的数字，所以新的扫描位置将会在整个浮点型数据的后面。double指针指向的地址存储的数据为扫描出的值，包括溢出时的`HUGE_VAL或者 –HUGE_VAL`，即未溢出时的0.0

**`scanFloat`**
扫描单精度浮点型字符，具体内容同scanDouble

**`scanHexDouble`**
扫描双精度的十六进制类型，溢出和非溢出都被认为合法的浮点型数据。在溢出的情况下scanner将会跳过所有的数字，所以新的扫描位置将会在整个浮点型数据的后面。double指针指向的地址存储的数据为扫描出的值，包括溢出时的HUGE_VAL或者 –HUGE_VAL，即未溢出时的0.0。数据接收时对应的格式为 %a 或%A ，双精度十六进制字符前面一定要加  0x或者 0X

**`scanHexInt`**
扫描十六进制无符整型，unsigned int指针指向的地址值为 扫描到的值，包含溢出时的UINT_MAX

**`scanLongLong`**
扫描LongLong 型，溢出也被认为是有效的整型，LongLong指针指向的地址的值为扫描到的值，包含溢出时的LLONG_MAX 或 LLONG_MIN


