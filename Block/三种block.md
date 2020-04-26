# 三种block

在Objective-C 语言中，一共有3种block：

1、_NSConcreteGlobalBlock, 全局的静态block，不会访问任何外部变量  
2、_NSConcreteStackBlock, 保存在栈中的block，当函数返回时会被销毁  
3、_NSConcreteMallocBlock, 保存在堆中的block，当引用计数为0时会被销毁  

