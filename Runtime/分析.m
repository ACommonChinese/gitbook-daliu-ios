[self doSomethingWithVar:var1];

objc_msgSend(self,@selector(doSomethingWithVar:),var1);

/// objc_object: Represents an instance of a class.

typedef struct objc_object *id;    /// A pointer to an instance of a class.
typedef struct objc_class *Class;  /// An opaque type that represents an Objective-C class.
typedef struct objc_selector *SEL; /// An opaque type that represents a method selector.

struct objc_class : objc_object {
    // Class ISA;
    Class superclass;
    cache_t cache;             // formerly cache pointer and vtable
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags

    class_rw_t *data() { 
        return bits.data();
    }
    void setData(class_rw_t *newData) {
        bits.setData(newData);
    }

    // ...
}

objc_object结构体:
-- objc.h --
/// Represents an instance of a class.
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY; // 这里的isa指向的是类
};

-- objc-private.h --



objc-object.h
inline Class 
objc_object::getIsa() {

}

// objc-class.mm
Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}

// objc-object.h
inline Class 
objc_object::getIsa() 
{
    if (!isTaggedPointer()) return ISA();

    uintptr_t ptr = (uintptr_t)this;
    if (isExtTaggedPointer()) {
        uintptr_t slot = 
            (ptr >> _OBJC_TAG_EXT_SLOT_SHIFT) & _OBJC_TAG_EXT_SLOT_MASK;
        return objc_tag_ext_classes[slot];
    } else {
        uintptr_t slot = 
            (ptr >> _OBJC_TAG_SLOT_SHIFT) & _OBJC_TAG_SLOT_MASK;
        return objc_tag_classes[slot];
    }
}

// objc-object.h
inline Class 
objc_object::ISA() 
{
    assert(!isTaggedPointer()); 
#if SUPPORT_INDEXED_ISA
    if (isa.nonpointer) {
        uintptr_t slot = isa.indexcls;
        return classForIndex((unsigned)slot);
    }
    return (Class)isa.bits; // 重点, 这里的isa是objc-private.h中的struct objc_object结构体中的一个指针
#else
    return (Class)(isa.bits & ISA_MASK);
#endif
}

===============================
		objc-internal.h
===============================
tagged pointer: 参考: https://www.jianshu.com/p/6389ee83a188

static inline bool 
_objc_taggedPointersEnabled(void)
{
    extern uintptr_t objc_debug_taggedpointer_mask;
    return (objc_debug_taggedpointer_mask != 0);
}


生成 Tagged Pointer 的函数：
static inline void * _Nonnull
_objc_makeTaggedPointer(objc_tag_index_t tag, uintptr_t value)
{
    // PAYLOAD_LSHIFT and PAYLOAD_RSHIFT are the payload extraction shifts.
    // They are reversed here for payload insertion.

    // assert(_objc_taggedPointersEnabled());
    if (tag <= OBJC_TAG_Last60BitPayload) {
        // assert(((value << _OBJC_TAG_PAYLOAD_RSHIFT) >> _OBJC_TAG_PAYLOAD_LSHIFT) == value);
        return (void *)
            (_OBJC_TAG_MASK | 
             ((uintptr_t)tag << _OBJC_TAG_INDEX_SHIFT) | 
             ((value << _OBJC_TAG_PAYLOAD_RSHIFT) >> _OBJC_TAG_PAYLOAD_LSHIFT));
    } else {
        // assert(tag >= OBJC_TAG_First52BitPayload);
        // assert(tag <= OBJC_TAG_Last52BitPayload);
        // assert(((value << _OBJC_TAG_EXT_PAYLOAD_RSHIFT) >> _OBJC_TAG_EXT_PAYLOAD_LSHIFT) == value);
        return (void *)
            (_OBJC_TAG_EXT_MASK |
             ((uintptr_t)(tag - OBJC_TAG_First52BitPayload) << _OBJC_TAG_EXT_INDEX_SHIFT) |
             ((value << _OBJC_TAG_EXT_PAYLOAD_RSHIFT) >> _OBJC_TAG_EXT_PAYLOAD_LSHIFT));
    }
}
翻译为:
static inline void * _Nonnull
_objc_makeTaggedPointer(objc_tag_index_t tag, uintptr_t value)
{
    // PAYLOAD_LSHIFT and PAYLOAD_RSHIFT are the payload extraction shifts.
    // They are reversed here for payload insertion.

    // assert(_objc_taggedPointersEnabled());
    if (tag <= 6) {
        // assert(((value << _OBJC_TAG_PAYLOAD_RSHIFT) >> _OBJC_TAG_PAYLOAD_LSHIFT) == value);
        return (void *)
            (1U | 
             ((uintptr_t)tag << 1) | 
             ((value << 4) >> 0));
    } else {
        // assert(tag >= OBJC_TAG_First52BitPayload);
        // assert(tag <= OBJC_TAG_Last52BitPayload);
        // assert(((value << _OBJC_TAG_EXT_PAYLOAD_RSHIFT) >> _OBJC_TAG_EXT_PAYLOAD_LSHIFT) == value);
        return (void *)
            (1U |
             ((uintptr_t)(tag - 8) << 52) |
             ((value << 12) >> 12));
    }
}



```


从apple给出的声明中，可以得到：



(4) 如果tag位是0b111,表示该对象使用了是"扩展"的标签对象，这种方式 allowing more classes but with smaller payloads, 这时: 
以iPhone为例: [ 1 bit表示是否是tagged pointer、 3 bit(0b111)、8 bit表示扩展tag、52 bit表示payload]

比如: https://blog.csdn.net/WangErice/article/details/91048938
NSNumber *number0 = @(12)
假设它在内存中地址如下:
0xb0000000000000c0, 换成二进制为:
1 011 00000000000000000000000000000000000000000000000000001100 0000   [进制转换在线工具](https://tool.lu/hexconvert/)
最高四位0xb=1011,其中: 
最高位为1，表明该指针并不是真正的对象指针，而是一个标签指针Tagged pointer
紧接着三位是011(3)，对应的value的实际类型为NSNumber类型 TODO:// 0表示char类型，1表示short类型，2表示整形，3表示长整型，4表示单精度类型，5表示双精度类型.
中间52位为实际负载值: 即000...1100, 表示12, 而最后四位则更加具体地表明了实际类型：
0表示char类型，1表示short类型，2表示整形，3表示长整型，4表示单精度类型，5表示双精度类型.

而需要注意的是，之所以采用了标签指针来做小数据的存储是因为对象指针可以完整表示标签+实际值组合，如果这个组合的实际值超出了对象指针可以表示的范围，还是要使用真正的对象指针来表示实际的对象空间。
所以变量number6并不是标签指针，而是使用了普通对象开辟新的地址空间来进行存储.

a
a000000000000611
1bit 标识 
3bit tag 
56bit payload
最后4位??
1 010 00000000000000000000000000000000000000000000000001100001 0001



https://blog.csdn.net/WangErice/article/details/91048938


// Tagged pointer layout and usage is subject to change on different OS versions.

// Tag indexes 0..<7 have a 60-bit payload.
// Tag index 7 is reserved.
// Tag indexes 8..<264 have a 52-bit payload.
// Tag index 264 is reserved.


