# ForwardingTarget


ForwardingTarget也被称为快速转发(Fast Forwarding), resolve method之后, runtime然后会检查你是否想将此消息不做改动的转发给另外一个对象，这是比较常见的消息转发情形，可以用较小的消耗完成。
快速转发技术可以用来实现伪多继承，你只需编写如下代码

```
- (id)forwardingTargetForSelector:(SEL)sel { return _otherObject; }
```

这样做会将任何位置的消息都转发给_otherObject对象，尽管当前对象与_otherObject对象是包含关系，但从外界看来当前对象和_otherObject像是同一个对象。
伪多继承与真正的多继承的区别在于，真正的多继承是将多个类的功能组合到一个对象中，而消息转发实现的伪多继承，对应的功能仍然分布在多个对象中，但是将多个对象的区别对消息发送者透明  

-----------------------------

这一步主要是做重定向target的消息转发, `forwardingTargetForSelector`, 当向一个对象发一个方法时, 此方法找不到, 那么Runtime会先去找resolve method, 即: 

```objective-c
+ (BOOL)resolveInstanceMethod:(SEL)sel {}
+ (BOOL)resolveClassMethod:(SEL)sel {}
```

如果resolve method阶段返回NO, 代表不予处理, 那么就会到第二阶段: `- (id)forwardingTargetForSelector:(SEL)aSelector {}`,  在这个时候如果返回一个新的target, 那么就会调用这个新的target的方法, 这就是消息转发. 比如[这里](../../Block/循环引用.md)就是一个使用场景, 由于Timer会强引用target, 因此通过Proxy作一层转发, 不让Time强引用target.  


