# App启动优化

用户能感知到的启动慢，其实都发生在主线程上。而主线程慢的原因有很多，比如在主线程上执行了大文件读写操作、在渲染周期中执行了大量计算等。但是，有时你会发现即使你把首屏显示之前的这些主线程的耗时问题都解决了，还是比竞品启动得慢。那么，究竟如何才能把启动时的所有耗时都找出来呢？解决这个问题，你首先需要弄清楚 App 在启动时都干了哪些事儿。  

一般而言，App 的启动时间，指的是从用户点击 App 开始，到用户看到第一个界面之间的时间。总结来说，App 的启动主要包括三个阶段：

1. main() 函数执行前；
2. main() 函数执行后；
3. 首屏渲染完成后。

[WWDC](https://developer.apple.com/videos/play/wwdc2016/406/)

