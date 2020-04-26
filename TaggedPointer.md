# TaggedPointer

[https://www.mikeash.com/pyblog/friday-qa-2012-07-27-lets-build-tagged-pointers.html](https://www.mikeash.com/pyblog/friday-qa-2012-07-27-lets-build-tagged-pointers.html)

```objective-c
NSString *testStr1 = @"a"; // 0x100001038
NSString *testStr2 = [NSString stringWithString:@"b"]; // 0x100001018
NSString *testStr3 = [NSString stringWithFormat:@"c"]; // 0x10eef1edd84dc043
NSString *testStr4 = [[NSString alloc] initWithString:@"d"]; // 0x100001078
NSString *testStr5 = [[NSString alloc] initWithFormat:@"e"]; // 0x10eef1edd84dc643
NSLog(@"%p", testStr1);
NSLog(@"%p", testStr2);
NSLog(@"%p", testStr3);
NSLog(@"%p", testStr4);
NSLog(@"%p", testStr5);
```

通过打印的地址我们发现,test1,test2,test4都是在一个内存区域,其实就是常量内存区. test3,test5在一个内存区，也就是堆区. 

```
"c": 内存地址: 0x10eef1edd84dc043
"e": 内存地址: 0x10eef1edd84dc643
```

字母c对应地址中的043, 字母e对应地址中的643, 

