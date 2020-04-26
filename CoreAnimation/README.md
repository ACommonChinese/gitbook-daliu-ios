# CoreAnimation

[这里](https://github.com/qunten/iOS-Core-Animation-Advanced-Techniques)是网友对一本国外的Core Animation图书的翻译版.  

每一个UIview都有一个CALayer实例的图层属性，也就是所谓的backing layer，视图的职责就是创建并管理这个图层，以确保当子视图在层级关系中添加或者被移除的时候，他们关联的图层也同样对应在层级关系树当中有相同的操作.   

UIView用于处理touch事件, CALayer处理绘制, 动画; UIView仅仅是对CALayer的一个封装，提供了一些iOS类似于处理触摸的具体功能，以及Core Animation底层方法的高级接口。  

这里有一些`UIView`没有暴露出来的CALayer的功能：

- 阴影，圆角，带颜色的边框
- 3D变换
- 非矩形范围
- 透明遮罩
- 多级非线性动画
