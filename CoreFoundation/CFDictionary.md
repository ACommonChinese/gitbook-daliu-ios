# CFDictionary


**CFDictionary相关API使用**

> 创建不可变/可变字典

CFDictionaryCreate / CFDictionaryCreateMutable / CFDictionaryCreateCopy

```Objective-C
CFDictionaryCreate (CFAllocatorRef allocator, // 为新字典分配内存。通过NULL或kCFAllocatorDefault使用当前默认的分配器
                      const void **keys, 	  // key的数组。如果numValues参数为0，则这个值可能是NULL。这个函数没有改变或释放这个数组。该值必须是有效的C数组
                      const void **values,    // value的数组(同上)
                      CFIndex numValues,      // 键值对数目。>=0 && >=实际数目
                      const CFDictionaryKeyCallBacks*keyCallBacks,    // 键的回调
                      const CFDictionaryValueCallBacks*valueCallBacks // 键的回调
                      );
```

```Objective-C
typedef struct {
    CFIndex				version;
    CFDictionaryRetainCallBack		retain;
    CFDictionaryReleaseCallBack		release;
    CFDictionaryCopyDescriptionCallBack	copyDescription;
    CFDictionaryEqualCallBack		equal;
    CFDictionaryHashCallBack		hash;
} CFDictionaryKeyCallBacks;

typedef struct {
    CFIndex				version;
    CFDictionaryRetainCallBack		retain;
    CFDictionaryReleaseCallBack		release;
    CFDictionaryCopyDescriptionCallBack	copyDescription;
    CFDictionaryEqualCallBack		equal;
} CFDictionaryValueCallBacks;
```

示例：
```Objective-C
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CFStringRef keys[2];
        keys[0] = CFSTR("key1");
        keys[1] = CFSTR("key2");
        CFStringRef values[2];
        values[0] = CFSTR("this is the first string");
        values[1] = CFSTR("this is the second string");
        CFDictionaryRef dictRef = CFDictionaryCreate(kCFAllocatorDefault,
                                                     (void *)keys,
                                                     (void *)values,
                                                     2,
                                                     &kCFTypeDictionaryKeyCallBacks,
                                                     &kCFTypeDictionaryValueCallBacks);
        NSLog(@"%@", dictRef);
    }
    return 0;
}
```

> CFDictionaryGetCount 返回键值对数目

```Objective-C
CFIndex CFDictionaryGetCount ( CFDictionaryRef theDict );
```

> CFDictionaryContainsValue/Key  检测一个值/键是否包含在字典内

```C
Boolean CFDictionaryContainsValue ( CFDictionaryRef theDict, const void *value);
Boolean CFDictionaryContainsKey ( CFDictionaryRef theDict, const void *key );
```

> CFDictionaryGetKeysAndValues 返回一个 keys的C数组 和 一个vlaue的C数组

```C
void CFDictionaryGetKeysAndValues ( CFDictionaryRef theDict , 
                                    const void ** keys , 
                                    const void ** values );
```

> CFDictionaryApplyFunction 对所有键值对执行一个方法

```C
void CFDictionaryApplyFunction ( CFDictionaryRef theDict ,
                                 CFDictionaryApplierFunction applier , 
                                 void * context );
```

示例：

```Objective-C

// typedef void (*CFDictionaryApplierFunction)(const void *key, const void *value, void *context);
void applier(const void *key, const void *value, void *context) {
    NSLog(@"did get key: %@  value: %@", (__bridge NSString *)key, (__bridge NSString *)value);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        CFStringRef keys[2];
        keys[0] = CFSTR("key1");
        keys[1] = CFSTR("key2");
        CFStringRef values[2];
        values[0] = CFSTR("this is the first string");
        values[1] = CFSTR("this is the second string");
        CFDictionaryRef dictRef = CFDictionaryCreate(kCFAllocatorDefault,
                                                     (void *)keys,
                                                     (void *)values,
                                                     2,
                                                     &kCFTypeDictionaryKeyCallBacks,
                                                     &kCFTypeDictionaryValueCallBacks);
        CFDictionaryApplyFunction(dictRef, applier, NULL);
    }
    return 0;
}
```

