# 在子类中处理Delegate消息

消息转发的使用场景示例: 使用消息转发在子类中处理Delegate消息  

当继承一个具有delgate的类,而又需要在子类中处理某些delegate消息，而又不影响对正常Delegate消息的调用时，需要如何处理呢？  

比如自定义一个`MyScrollView : UIScrollView`, 一种方法是设置.deleagte = myScrollView, 而将外部设置的delegate存储到另一个参数中, 在子类中实现所有的delegate方法，处理子类中需要处理的delegate消息，而将子类中不处理的delegate消息再发送到外部delegate。这种方法的缺点在于实现繁琐，在子类中需要实现所有delegate方法，尽管大部分delegate消息又直接转给了外部delegate处理

```objective-c
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyScrollView : UIScrollView

@end

NS_ASSUME_NONNULL_END
```

```objective-c
#import "MyScrollView.h"

@interface MyScrollView() <UIScrollViewDelegate>

@property (nonatomic, weak) id<UIScrollViewDelegate> outerDelegate;

@end

@implementation MyScrollView

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    self.outerDelegate = delegate;
    [super setDelegate:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"do something here");
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.outerDelegate scrollViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.outerDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.outerDelegate && [self.outerDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.outerDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

// ...

@end
```

```objective-c
#import "ViewController.h"
#import "MyScrollView.h"

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyScrollView *scrollView = [[MyScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor redColor];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 1000)];
    [self.view addSubview:scrollView];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"outer scroll view did scroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"outer scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"outer scrollViewDidEndDecelerating:");
}

@end
```

使用这种方法必须实现繁琐的其他需要传递的方法, 因此可以使用第二种解决方案即转发解决这种问题:  

**MessageInterceptor.h/m**  
```
#import <Foundation/Foundation.h>

@interface MessageInterceptor : NSObject

@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id middleMan;

@end

// ---------------------------------

#import "MessageInterceptor.h"

@implementation MessageInterceptor

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (_middleMan && [_middleMan respondsToSelector:aSelector]) {
        return _middleMan;
    }
    if (_receiver && [_receiver respondsToSelector:aSelector]) {
        return _receiver;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (_middleMan && [_middleMan respondsToSelector:aSelector]) {
        return YES;
    }
    if (_receiver && [_receiver respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

@end
```

**MyScrollView.h/m**

```objective-c
#import <UIKit/UIKit.h>

@interface MyScrollView : UIScrollView

@end

// ---------------------------------

#import "MyScrollView.h"
#import "MessageInterceptor.h"

@interface MyScrollView() <UIScrollViewDelegate>
@end

@implementation MyScrollView {
    MessageInterceptor *_interceptor;
}

- (id<UIScrollViewDelegate>)delegate {
    return _interceptor.receiver;
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    [super setDelegate:nil];
    _interceptor = MessageInterceptor.new;
    _interceptor.middleMan = self;
    _interceptor.receiver = delegate;
    [super setDelegate:(id)_interceptor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"do something here");
    if (_interceptor.receiver && [_interceptor.receiver respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_interceptor.receiver scrollViewDidScroll:self];
    }
}

@end
```

**测试代码**   
```objective-c
#import "ViewController.h"
#import "MyScrollView.h"

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyScrollView *scrollView = [[MyScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor redColor];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 1000)];
    [self.view addSubview:scrollView];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"outer scroll view did scroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"outer scrollViewWillBeginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"outer scrollViewDidEndDecelerating:");
}

@end
```