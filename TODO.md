# TODO

mysql的rint函数中的一个宏定义:

/**
  All integers up to this number can be represented exactly as double precision(双精度数)
  values (DBL_MANT_DIG == 53 for IEEE 754 hardware).
*/
```
#define MAX_EXACT_INTEGER ((1LL << DBL_MANT_DIG) - 1)
```

根据IEEE754的规范, 双精度double格式为8字节64位，由三个字段组成：52 位小数 f ； 11 位偏置指数 e ；以及 1 位符号 s

[63]   [62 : 52]   [51 : 32]

意思是, 所有的integer在没有大于这个双精度double值之前, 都可以强转为double, 不会造成数据精度丢失
如果integer的值大于这个值, 则double可以强转为long long, 不会造成精度丢失