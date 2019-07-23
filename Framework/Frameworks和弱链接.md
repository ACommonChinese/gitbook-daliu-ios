# Frameworks和弱链接

[官网](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WeakLinking.html#//apple_ref/doc/uid/20002378-106633)

One challenge faced by developers is that of taking advantage of new features introduced in new versions of OS X while still supporting older versions of the system. Normally, if an application uses a new feature in a framework, it is unable to run on earlier versions of the framework that do not support that feature. Such applications would either fail to launch or crash when an attempt to use the feature was made. Apple has solved this problem by adding support for weakly-linked symbols.

When a symbol in a framework is defined as weakly linked, the symbol does not have to be present at runtime for a process to continue running. The static linker identifies a weakly linked symbol as such in any code module that references the symbol. The dynamic linker uses this same information at runtime to determine whether a process can continue running. If a weakly linked symbol is not present in the framework, the code module can continue to run as long as it does not reference the symbol. However, if the symbol is present, the code can use it normally.

If you are updating your own frameworks, you should consider making new symbols weakly linked. Doing so can make it easier for clients of your framework to support it. You should also make sure that your own code checks for the existence of weakly-linked symbols before using them.

When you create a new project, you tell the compiler which versions of OS X your project supports by setting the deployment target and target SDK in Xcode. The compiler uses these settings to assign appropriate values to the MAC_OS_X_VERSION_MIN_REQUIRED and MAC_OS_X_VERSION_MAX_ALLOWED macros, respectively. 

For example, suppose in Xcode you set the deployment target (minimum required version) to OS X v10.2 and the target SDK (maximum allowed version) to OS X v10.3. During compilation, the compiler would weakly link any interfaces that were introduced in OS X version 10.3 while strongly linking earlier interfaces. This would allow your application to continue running on OS X version 10.2 but still take advantage of newer features when they are available.

To mark a function or variable as weakly linked, add the weak_import attribute to the function prototype or variable declaration, as shown in the following example:

```Objective-C
extern int MyFunction() __attribute__((weak_import));
extern int MyVariable __attribute__((weak_import));
```

Check weakly linked symbols:

```Objective-C
extern int MyWeakLinkedFunction() __attribute__((weak_import));
 
int main() {
    int result = 0;
 
    if (MyWeakLinkedFunction != NULL) { // Note: When checking for the existence of a symbol, you must explicitly compare it to NULL or nil in your code. You cannot use the negation operator ( ! ) to negate the address of the symbol.
        result = MyWeakLinkedFunction();
    }
 
    return result;
}
```

如果工程依赖于一个framework，想weak link它，在Target的Build Phases中的Link Binayr With Libraries中把它置为optional即可。
[https://stackoverflow.com/questions/33038137/xcode-and-optional-frameworks](https://stackoverflow.com/questions/33038137/xcode-and-optional-frameworks)






 








