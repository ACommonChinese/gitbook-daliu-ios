# UIScrollView高亮选中

```
// 属性
self.canCancelContentTouches = YES;
```
// https://blog.csdn.net/u012845800/article/details/16801363?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase
    // Apple: If the value of this property is YES and a view in the content has begun tracking a finger touching it, and if the user drags the finger enough to initiate a scroll, the view receives a touchesCancelled:withEvent: message and the scroll view handles the touch as a scroll.
    // If the value of this property is NO, the scroll view does not scroll regardless of finger movement once the content view starts tracking.


Returns whether to cancel touches related to the content subview and start dragging.
If the value of this property is YES and a view in the content has begun tracking a finger touching it, and if the user drags the finger enough to initiate a scroll, the view receives a touchesCancelled:withEvent: message and the scroll view handles the touch as a scroll. If the value of this property is NO, the scroll view does not scroll regardless of finger movement once the content view starts tracking.
```
// OC
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

// Swift
func touchesShouldCancel(in view: UIView) -> Bool
```

首先, 在继承UIScrollViwe的子类上覆写此方法, 返回YES, 即告诉scroll view可以取消content view上的事件. 



### UIControl

```
// OC
- (void)cancelTrackingWithEvent:(UIEvent *)event;

// swift
func cancelTracking(with event: UIEvent?)
```

Tells the control to cancel tracking related to the given event.

The control calls this method when a control-related touch event is cancelled. The default implementation cancels any ongoing tracking and updates the control’s state information. Subclasses can override this method and use it to perform any actions relevant to the cancellation of the touch sequence. You should also use it to perform any cleanup associated with tracking the event.

If you override this method, you must call super at some point in your implementation.