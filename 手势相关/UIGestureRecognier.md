# UIGestureRecognier

参考链接：  
[https://www.jianshu.com/p/ce86d57e40cf](https://www.jianshu.com/p/ce86d57e40cf)  
[https://www.jianshu.com/p/ef60a6c10a8d](https://www.jianshu.com/p/ef60a6c10a8d)

**cancelsTouchesInView**  
 When this property is YES \(the default\) and the receiver recognizes its gesture, the touches of that gesture that are pending are not delivered to the view and previously delivered touches are cancelled through a touchesCancelled:withEvent: message sent to the view. If a gesture recognizer doesn’t recognize its gesture or if the value of this property is NO, the view receives all touches in the multi-touch sequence.  
如果此属性是YES，当手势被识别后，touch事件就不再触发。示例：

```Objective-C
- (void)test {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.cancelsTouchesInView = YES; // default
    [self.view addGestureRecognizer:pan];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"move ...");
}

-(void)pan:(UIPanGestureRecognizer *)pan{
    NSLog(@"识别出手势");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"cancel....");
}

打印结果：
move ...
move ...
move ...
move ...
move ...
move ...
识别出手势
cancel....
识别出手势
识别出手势
识别出手势
...
```

如果改为`pan.cancelsTouchesInView = NO;`，则即使识别出了手势，touch也不会被取消，打印结果：

```Objective-C
move ...
move ...
move ...
识别出手势
move ...
识别出手势
识别出手势
move ...
识别出手势
move ...
识别出手势
move ...
识别出手势
move ...
识别出手势
move ...
识别出手势
move ...
识别出手势
move ...
```

可见，`cancelsTouchesInView=NO`表示手势识别出后，touch事件会继续被识别，而设置成`cancelsTouchesInView=YES`（默认）后，手势事件被识别出后，会调用touchesCancelled，然后touch事件就没有再被触发回调。  
但是我们注意到，即使`cancelsTouchesInView=YES`,touch事件也会首先被调用几次，如上示例move...方法被调用了多次后cancel...才被调用，这是因为手势识别是有一个过程的，拖拽手势需要一个很小的手指移动的过程才能被识别为拖拽手势，而在一个手势触发之前，是会一并发消息给事件传递链的，所以才会有最开始的几个touchMoved方法被调用，当识别出拖拽手势以后，就会终止touch事件的传递。即touch事件不再传递是在`receiver recognizes its gesture`之后。如果在手势被识别之前也不要touch被识别回调，可以设置`delaysTouchesBegan`

**delaysTouchesBegan**  
改写上面的示例代码：

```Objective-C
pan.cancelsTouchesInView = YES;
pan.delaysTouchesBegan = YES;
```

打印结果：

```
识别出手势
识别出手势
识别出手势
识别出手势
识别出手势
识别出手势
识别出手势
识别出手势
识别出手势
...
```

**delaysTouchesEnded**

> When the value of this property is YES \(the default\) and the receiver is analyzing touch events, the window suspends delivery of touch objects in the UITouchPhaseEnded phase to the attached view. If the gesture recognizer subsequently recognizes its gesture, these touch objects are cancelled \(via a touchesCancelled:withEvent: message\). If the gesture recognizer does not recognize its gesture, the window delivers these objects in an invocation of the view’s touchesEnded:withEvent: method. Set this property to NO to have touch objects in the UITouchPhaseEnded delivered to the view while the gesture recognizer is analyzing the same touches.

```Objective-C
- (void)test2 {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 3; // 连续点击三下
    tap.delaysTouchesEnded = NO; // 默认YES
    [self.view addGestureRecognizer:tap];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"begin ...");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"cancel ...");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"end ...");
}

-(void)tap:(UITapGestureRecognizer *)tap {
    NSLog(@"tap手势触发");
}

@end
```

打印结果：

```
begin ...
end ...
begin ...
end ...
begin ...
tap手势触发
cancel ...
```

改成：`tap.delaysTouchesEnded = YES;`，打印结果：

```Objective-C
begin ...
tap手势触发
cancel ...
```



