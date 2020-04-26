# category

参考: 
- [https://stackoverflow.com/questions/3221972/what-happens-if-two-objc-categories-override-the-same-method](https://stackoverflow.com/questions/3221972/what-happens-if-two-objc-categories-override-the-same-method)  

What happens if two ObjC categories override the same method?

Categories are really just a means of organizing source files. When compiled, all the methods of a class, including the ones defined in any category, end up in the same file.

Anything you could do in a regular class interface you can do in a category and anything you shouldn't do in a regular class interface you shouldn't do in a category.  

So:
  > Category methods should not override existing methods (class or instance)  

You can use methods defined in the regular class interface to override inherited methods so you can override inherited methods in a category.  
However, you would never try to have to two identical method definitions in the same ordinary interface so you should never have a method in a category that has the same name as a method in either the ordinary interface or another category on the same class. Since all the method definitions end up in the same compiled file, they would obviously collide.  
> Two different categories implementing the same method results in undefined behavior  
> 

That should be rewritten to say "Two different categories implementing the same method for the same class results in undefined behavior." Again, because all the methods for any one class end up in the same file, having two methods in the same class would obviously cause weirdness.

You can use categories to provide methods that override superclass methods because a class and its superclass are two distinct classes.  

先看来一个category结构体:

```objective-c
// objc-runtime-new.h
struct category_t {
    const char *name;
    classref_t cls;
    // 实例方法列表
    struct method_list_t *instanceMethods;
    // 类方法列表
    struct method_list_t *classMethods;
    // 协议列表
    struct protocol_list_t *protocols;
    struct property_list_t *instanceProperties;
    // Fields below this point are not always present on disk.
    struct property_list_t *_classProperties;

    method_list_t *methodsForMeta(bool isMeta) {
        if (isMeta) return classMethods;
        else return instanceMethods;
    }

    property_list_t *propertiesForMeta(bool isMeta, struct header_info *hi);
};
```

我们先去写一个category看一下category到底为何物:  

```objective-c
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyClass : NSObject

- (void)printName;

@end

@interface MyClass(MyAddition)
 
@property(nonatomic, copy) NSString *name;
 
- (void)printName;

@end

NS_ASSUME_NONNULL_END
```

```objective-c
#import "MyClass.h"

@implementation MyClass

- (void)printName
{
    NSLog(@"%@",@"MyClass");
}

@end

@implementation MyClass(MyAddition)
 
- (void)printName
{
    NSLog(@"%@",@"MyAddition");
}
 
@end
```

使用clang的命令去看看category到底会变成什么：

```
clang -rewrite-objc MyClass.m
```

这会在当前目录下生成一个叫`MyClass.cpp`的c++文件, 我们只看一些核心代码: 

```c
static struct /*_method_list_t*/ {
	unsigned int entsize;  // sizeof(struct _objc_method)
	unsigned int method_count;
	struct _objc_method method_list[1];
} _OBJC_$_CATEGORY_INSTANCE_METHODS_MyClass_$_MyAddition __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	sizeof(_objc_method),
	1,
	{{(struct objc_selector *)"printName", "v16@0:8", (void *)_I_MyClass_MyAddition_printName}}
};

static struct /*_prop_list_t*/ {
	unsigned int entsize;  // sizeof(struct _prop_t)
	unsigned int count_of_properties;
	struct _prop_t prop_list[1];
} _OBJC_$_PROP_LIST_MyClass_$_MyAddition __attribute__ ((used, section ("__DATA,__objc_const"))) = {
	sizeof(_prop_t),
	1,
	{{"name","T@\"NSString\",C,N"}}
};

extern "C" __declspec(dllexport) struct _class_t OBJC_CLASS_$_MyClass;

static struct _category_t _OBJC_$_CATEGORY_MyClass_$_MyAddition __attribute__ ((used, section ("__DATA,__objc_const"))) = 
{
	"MyClass",
	0, // &OBJC_CLASS_$_MyClass,
  // 编译器生成了实例方法列表_OBJC_$_CATEGORY_INSTANCE_METHODS_MyClass_$_MyAddition
  // 和属性列表 _OBJC_$_PROP_LIST_MyClass_$_MyAddition
  // 而且实例方法列表里面填充的正是我们在MyAddition这个category里面写的方法printName，
  // 而属性列表里面填充的也正是我们在MyAddition里添加的name属性
	(const struct _method_list_t *)&_OBJC_$_CATEGORY_INSTANCE_METHODS_MyClass_$_MyAddition,
	0,
	0,
	(const struct _prop_list_t *)&_OBJC_$_PROP_LIST_MyClass_$_MyAddition,
};
static void OBJC_CATEGORY_SETUP_$_MyClass_$_MyAddition(void ) {
	_OBJC_$_CATEGORY_MyClass_$_MyAddition.cls = &OBJC_CLASS_$_MyClass;
}
#pragma section(".objc_inithooks$B", long, read, write)
__declspec(allocate(".objc_inithooks$B")) static void *OBJC_CATEGORY_SETUP[] = {
	(void *)&OBJC_CATEGORY_SETUP_$_MyClass_$_MyAddition,
};
static struct _class_t *L_OBJC_LABEL_CLASS_$ [1] __attribute__((used, section ("__DATA, __objc_classlist,regular,no_dead_strip")))= {
	&OBJC_CLASS_$_MyClass,
};
static struct _category_t *L_OBJC_LABEL_CATEGORY_$ [1] __attribute__((used, section ("__DATA, __objc_catlist,regular,no_dead_strip")))= {
	&_OBJC_$_CATEGORY_MyClass_$_MyAddition,
};
static struct IMAGE_INFO { unsigned version; unsigned flag; } _OBJC_IMAGE_INFO = { 0, 2 };
```

对于OC运行时，入口方法如下（在objc-os.mm文件中) 

```objective-c
void _objc_init(void)
{
    static bool initialized = false;
    if (initialized) return;
    initialized = true;
    
    // fixme defer initialization until an objc-using image is found?
    environ_init();
    tls_init();
    static_init();
    lock_init();
    exception_init();

    _dyld_objc_notify_register(&map_images, load_images, unmap_image);
}
```

category被附加到类上面是在map_images的时候发生的，在new-ABI的标准下，_objc_init里面的调用的map_images最终会调用objc-runtime-new.mm里面的_read_images方法，而在_read_images方法的结尾，有以下的代码片段：

```objective-c
    // Discover categories. 
    for (EACH_HEADER) {
        category_t **catlist = 
            _getObjc2CategoryList(hi, &count);
        bool hasClassProperties = hi->info()->hasCategoryClassProperties();

        for (i = 0; i < count; i++) {
            category_t *cat = catlist[i];
            Class cls = remapClass(cat->cls);

            if (!cls) {
                // Category's target class is missing (probably weak-linked).
                // Disavow any knowledge of this category.
                catlist[i] = nil;
                if (PrintConnecting) {
                    _objc_inform("CLASS: IGNORING category \?\?\?(%s) %p with "
                                 "missing weak-linked target class", 
                                 cat->name, cat);
                }
                continue;
            }

            // Process this category. 
            // First, register the category with its target class. 
            // Then, rebuild the class's method lists (etc) if 
            // the class is realized. 
            bool classExists = NO;
            if (cat->instanceMethods ||  cat->protocols  
                ||  cat->instanceProperties) 
            {
                addUnattachedCategoryForClass(cat, cls, hi);
                if (cls->isRealized()) {
                    remethodizeClass(cls);
                    classExists = YES;
                }
                if (PrintConnecting) {
                    _objc_inform("CLASS: found category -%s(%s) %s", 
                                 cls->nameForLogging(), cat->name, 
                                 classExists ? "on existing class" : "");
                }
            }

            if (cat->classMethods  ||  cat->protocols  
                ||  (hasClassProperties && cat->_classProperties)) 
            {
                addUnattachedCategoryForClass(cat, cls->ISA(), hi);
                if (cls->ISA()->isRealized()) {
                    remethodizeClass(cls->ISA());
                }
                if (PrintConnecting) {
                    _objc_inform("CLASS: found category +%s(%s)", 
                                 cls->nameForLogging(), cat->name);
                }
            }
        }
    }
```

由上述代码可知:  
1)、把category的实例方法、协议以及属性添加到类上  
2)、把category的类方法和协议添加到类的metaclass上   

接着往里看，category的各种列表是怎么最终添加到类上的，就拿实例方法列表来说吧：
在上述的代码片段里，addUnattachedCategoryForClass只是把类和category做一个关联映射，而remethodizeClass才是真正去处理添加事宜的功臣:  

```objective-c
// objc-runtime-new.mm
static void remethodizeClass(Class cls)
{
    category_list *cats;
    bool isMeta;

    runtimeLock.assertWriting();

    isMeta = cls->isMetaClass();

    // Re-methodizing: check for more categories
    if ((cats = unattachedCategoriesForClass(cls, false/*not realizing*/))) {
        if (PrintConnecting) {
            _objc_inform("CLASS: attaching categories to class '%s' %s", 
                         cls->nameForLogging(), isMeta ? "(meta)" : "");
        }
        
        attachCategories(cls, cats, true /*flush caches*/);        
        free(cats);
    }
}
```