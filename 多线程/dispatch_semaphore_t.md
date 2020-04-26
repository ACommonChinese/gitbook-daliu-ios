# dispatch_semaphore_t

参考: 
- [https://www.jianshu.com/p/24ffa819379c](https://www.jianshu.com/p/24ffa819379c)
- [https://www.cnblogs.com/yajunLi/p/6274282.html](https://www.cnblogs.com/yajunLi/p/6274282.html)

### Why

- 假设现在系统有两个空闲资源可以被利用，但同一时间却有三个线程要进行访问，这种情况下可以使用信号量处理; 
- 我们要下载很多图片，并发异步进行，每个下载都会开辟一个新线程，可是我们又担心太多线程肯定cpu吃不消，那么我们这里也可以用信号量控制一下最大开辟线程数
- 并发队列中的任务，由于异步线程执行的顺序是不确定的，两个任务分别由两个线程执行，很难控制哪个任务先执行完，哪个任务后执行完。但有时候确实有这样的需求：两个任务虽然是异步的，但仍需要同步执行。这时候，GCD信号量就可以大显身手 
- 虽然异步函数 + 串行队列实现任务同步执行更加简单, 但是异步函数 + 串行队列的弊端也是非常明显的：因为是异步函数，所以系统会开启新（子）线程，又因为是串行队列，所以系统只会开启一个子线程。这就导致了所有的任务都是在这个子线程中同步的一个一个执行。丧失了并发执行的可能性。虽然可以完成任务，但是却没有充分发挥CPU多线程的优势

### What

GCD信号量：就是一种可用来控制访问资源的数量的标识，设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量数量来执行多个线程, GCD信号量机制主要涉及到以下三个函数

```objective-c
dispatch_semaphore_create(long value); // 创建信号量
dispatch_semaphore_signal(dispatch_semaphore_t deem); // 发送信号量
dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout); // 等待信号量
```

- `dispatch_semaphore_create(long value)`
  - 含义: 创建一个dispatch_semaphore_类型的信号量，并且创建的时候指定信号量的大小
- `dispatch_semaphore_wait(dispatch_semaphore_t dsema, dispatch_time_t timeout)`
  - 含义: 等待信号量。如果信号量值为0，那么该函数就会一直等待，相当于阻塞当前线程, 直到该函数等待的信号量的值大于等于1，该函数会对信号量的值进行减1操作
- `dispatch_semaphore_signal(dispatch_semaphore_t deem)`
  - 含义: 发送信号量。该函数会对信号量的值进行加1操作。

通常等待信号量和发送信号量的函数是成对出现的。并发执行任务时候，在当前任务执行之前，用dispatch_semaphore_wait函数进行等待（阻塞），直到上一个任务执行完毕后且通过dispatch_semaphore_signal函数发送信号量（使信号量的值加1），dispatch_semaphore_wait函数收到信号量之后判断信号量的值大于等于1，会再对信号量的值减1，然后当前任务可以执行，执行完毕当前任务后，再通过dispatch_semaphore_signal函数发送信号量（使信号量的值加1），通知执行下一个任务......如此一来，通过信号量，就达到了并发队列中的任务同步执行的要求

### How

一般的使用顺序是先降低(dispatch_semaphore_wait)然后再提高(dispatch_semaphore_signal)，这两个函数通常成对使用

```objective-c
- (void)testSeri {
    // 串行队列 + 异步 == 只会开启一个线程，且队列中所有的任务都是在这个线程执行
    dispatch_queue_t queue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"111:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"222:%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"333:%@",[NSThread currentThread]);
    });
}

- (void)testSemaphore {
    // 并行队列 + 异步 + 信号量, 多个线程, 也是串行执行
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSLog(@"任务1:%@",[NSThread currentThread]);
       dispatch_semaphore_signal(sem); // 1
    });
   
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSLog(@"任务2:%@",[NSThread currentThread]);
       dispatch_semaphore_signal(sem);
    });
   
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       NSLog(@"任务3:%@",[NSThread currentThread]);
    });
}
```

上面写法使用信号量实现异步线程同步操作时，虽然任务是一个接一个执行, 但因为是在并发队列，并不是所有的任务都是在同一个线程执行;  这有别于异步函数+串行队列的方式（异步函数+ 串行队列的方式中，所有的任务都是在同一个线程被串行执行的）

--------------------------------------------------

### 网络请求示例

示例, 分别执行两个异步请求, 第二个网络请求需要等待第一个网络请求响应后再执行，可以使用信号量的实现：

```objective-c
- (void)test {
    NSString *urlString1 = @"xxx";
    NSString *urlString2 = @"yyy";
    // 创建信号量
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString1 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"1完成！");
            // 发送信号量
            dispatch_semaphore_signal(sem);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"1失败！");
            // 发送信号量
            dispatch_semaphore_signal(sem);
        }];
    });

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 等待信号量
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString2 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"2完成！");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"2失败！");
        }];
    });
}
```

--------------------------------------------------

### 异步组DispatchGroup结合信号量

使用异步组(dispatch Group)可以实现在同一个组内的内务执行全部完毕之后再执行最后的处理。但是同一组内的block任务的执行顺序是不可控的: 

```objective-c
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{
    NSLog(@"1");
});
dispatch_group_async(group, queue, ^{
    NSLog(@"2");
});
dispatch_group_async(group, queue, ^{
    NSLog(@"3");
});

dispatch_group_notify(group, queue, ^{
    NSLog(@"1, 2, 3 all done");
});
```

上面的程序执行顺序可能是1, 2, 3也可能是2, 3, 1等其他组合, 最后走到"1, 2, 3, done".     

可以使用信号量让线程组中的线程同步执行:

```objective-c
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_semaphore_t sem = dispatch_semaphore_create(0);
dispatch_group_async(group, queue, ^{
    NSLog(@"1");
    dispatch_semaphore_signal(sem);
});
dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
dispatch_group_async(group, queue, ^{
    NSLog(@"2");
    dispatch_semaphore_signal(sem);
});
dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
dispatch_group_async(group, queue, ^{
    NSLog(@"3");
});

dispatch_group_notify(group, queue, ^{
    NSLog(@"1, 2, 3 all done");
});
```

上面程序按顺序1, 2, 3执行, 不过使用这种方式并不多见, 来看一种使用场景比较多的情况:

有时候我们希望使用异步函数并发执行完任务之后再异步回调到当前线程。当前线程的任务执行完毕后再执行最后的处理。这种操作，只使用dispatch group是不够的，还需要dispatch_semaphore_t（信号量）的加入。

示例:  

```objective-c
- (void)test1 {
    dispatch_group_t grp = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task1 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task1 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task2 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task2 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task3 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task3 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task4 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task4 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task5 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task5 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_async(grp, queue, ^{
        NSLog(@"task6 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task6 finish : %@",[NSThread currentThread]);
        });
    });
    dispatch_group_notify(grp, queue, ^{
        NSLog(@"END");
    });
}
```

其中一次运行结果: 

task3 begin : <NSThread: 0x6000019cf2c0>{number = 3, name = (null)}
task2 begin : <NSThread: 0x6000019af6c0>{number = 5, name = (null)}
task5 begin : <NSThread: 0x60000199d700>{number = 6, name = (null)}
task1 begin : <NSThread: 0x600001990540>{number = 4, name = (null)}
task4 begin : <NSThread: 0x6000019808c0>{number = 7, name = (null)}
task6 begin : <NSThread: 0x600001984680>{number = 8, name = (null)}
task2 finish : <NSThread: 0x6000019af6c0>{number = 5, name = (null)}
task5 finish : <NSThread: 0x60000199d700>{number = 6, name = (null)}
task1 finish : <NSThread: 0x600001984680>{number = 8, name = (null)}
task6 finish : <NSThread: 0x60000199dac0>{number = 9, name = (null)}
END
task3 finish : <NSThread: 0x6000019cf2c0>{number = 3, name = (null)}
task4 finish : <NSThread: 0x600001990540>{number = 4, name = (null)}

可见END的执行并不是在所有的线程执行完后而执行; 这是因为异步组只对自己的任务负责，并不会对自己任务中的任务负责，异步组把自己的任务执行完后会立即返回，并不会等待自己的任务中的任务执行完毕。  

### 使用dispatch_semaphore_

我们可以使用信号量解决这种问题, 在"任务A中的任务B"未执行完毕时阻止任务A结束, 等任务A中的任务B结束后才允许任务A结束:  

```objective-c
- (void)test2 {
    dispatch_group_t grp = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("concurrent.queue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSLog(@"task1 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task1 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSLog(@"task2 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task2 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSLog(@"task3 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task3 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSLog(@"task4 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task4 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSLog(@"task5 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"task5 finish : %@",[NSThread currentThread]);
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_async(grp, queue, ^{
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSLog(@"task6 begin : %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            dispatch_semaphore_signal(sem);
            NSLog(@"task6 finish : %@",[NSThread currentThread]);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(grp, queue, ^{
        NSLog(@"END");
    });
}
```

运行上面代码总会得到END的执行会在所有任务执行完毕后  

网络请求的示例: 假设把两个异步的网络请求放入线程组中, 让这两个请求全部返回后再做其他处理  

```objective-c
- (void)test {
    NSString *appIdKey = @"8781e4ef1c73ff20a180d3d7a42a8c04";
    NSString* urlString_1 = @"http://api.openweathermap.org/data/2.5/weather";
    NSString* urlString_2 = @"http://api.openweathermap.org/data/2.5/forecast/daily";
    NSDictionary* dictionary = @{xxx};
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将第一个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_1
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"1任务成功");
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"1任务失败");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore);
             }];
        // 在网络请求任务成功/失败之前，一直等待信号量（相当于阻塞，不会执行下面的操作）
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    // 将第二个网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 创建信号量
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        // 开始网络请求任务
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:urlString_2
          parameters:dictionary
            progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"2任务成功");
                 // 如果请求成功，发送信号量
                 dispatch_semaphore_signal(semaphore);
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"2任务失败");
                 // 如果请求失败，也发送信号量
                 dispatch_semaphore_signal(semaphore);
             }];
        // 在网络请求任务成功/失败之前，一直等待信号量（相当于阻塞，不会执行下面的操作）
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"1和2已经完成，执行任务3。");
    });
}
```

上面代码两个线程各自创建了一个信号量，所以任务1和任务2的执行顺序具有随机性，而任务3的执行一定会是在任务1和任务2执行完毕之后 

-----------------------------------------------

### groupEnter & groupLeave

对于上述操作也可以用dispatch_group_enter(dispatch_group_t group) 和 dispatch_group_leave(dispatch_group_t group)来实现:  

```objective-c
- (void)testGroup {
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    // 模拟多线程耗时操作
    dispatch_group_async(group, globalQueue, ^{
        dispatch_async(globalQueue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"1_2 End");
                dispatch_group_leave(group);
            });
        });
        NSLog(@"1_1 End");
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        dispatch_async(globalQueue, ^{
        
        注: 必须保证dispatch_group_enter()和dispatch_group_leave()是成对出现的，不然dispatch_group_notify()将永远不会被调用  
        
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"2_2 End");
                dispatch_group_leave(group);
            });
        });
        NSLog(@"2_1 End");
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, globalQueue, ^{
        dispatch_async(globalQueue, ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"3_2 End");
                dispatch_group_leave(group);
            });
        });
        NSLog(@"3_1 End");
    });
    
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"All End 1");
    });
    
    /** OK:
    dispatch_group_notify(group, globalQueue, ^{
        NSLog(@"All End 2");
    });
     */
}
```

注: 必须保证dispatch_group_enter()和dispatch_group_leave()是成对出现的，不然dispatch_group_notify()将永远不会被调用  



