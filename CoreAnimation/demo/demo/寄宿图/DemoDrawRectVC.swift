//
//  DemoDrawRectVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/19.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoDrawRectVC: UIViewController, CALayerDelegate {
    let layerView: UIView = UIView(frame: CGRectMake(0, 0, 200, 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        self.title = "寄宿图::drawRect"
        self.layerView.center = self.view.center
        self.view.addSubview(self.layerView)
        self.layerView.backgroundColor = UIColor.white
        
        layerDraw()
    }

    //除了使用给UIView的contents赋值设置寄宿图外，也可以通过CoreGraphics中的drawRect设置View的寄宿图
    //`-drawRect:` 方法没有默认的实现，因为对UIView来说，寄宿图并不是必须的，它不在意那到底是单调的颜色还是有一个图片的实例。如果UIView检测到`-drawRect:` 方法被调用了，它就会为视图分配一个寄宿图，这个寄宿图的像素尺寸等于视图大小乘以 `contentsScale`的值
    //苹果建议：如果没有自定义绘制的任务就不要在子类中写一个空的-drawRect:方法
    //当视图在屏幕上出现的时候 `-drawRect:`方法就会被自动调用。`-drawRect:`方法里面的代码利用Core Graphics去绘制一个寄宿图，然后内容就会被缓存起来直到它需要被更新（通常是因为开发者调用了`-setNeedsDisplay`方法，尽管影响到表现效果的属性值被更改时，一些视图类型会被自动重绘，如`bounds`属性）。虽然`-drawRect:`方法是一个UIView方法，事实上都是底层的CALayer安排了重绘工作和保存了因此产生的图片
    //当需要被重绘时，CALayer会请求它的代理(CALayerDelegate)给它一个寄宿图来显示:
    //func draw(_ layer: CALayer, in ctx: CGContext)
    //如果代理不实现`-displayLayer:`方法，CALayer就会转而尝试调用下面这个方法
    //在调用这个方法之前，CALayer创建了一个合适尺寸的空寄宿图（尺寸由`bounds`和`contentsScale`决定）和一个Core Graphics的绘制上下文环境，为绘制寄宿图做准备，它作为ctx参数传入
    
    func layerDraw() {
        //create sublayer
        let blueLayer = CALayer()
        blueLayer.frame = CGRectMake(50, 50, 100, 100)
        blueLayer.backgroundColor = UIColor.blue.cgColor
        
        //set controller as layer delegate
        blueLayer.delegate = self
        
        //ensure that layer backing image uses correct scale
        blueLayer.contentsScale = UIScreen.main.scale
        self.layerView.layer.addSublayer(blueLayer)
        
        //force layer to redraw
        //不同于UIView，当图层显示在屏幕上时，CALayer不会自动重绘它的内容。它把重绘的决定权交给了开发者
        blueLayer.display()
    }
    
    //MARK: - CALayerDelegate
    //在此代理方法中设置寄宿图
    /**
    func display(_ layer: CALayer) {
        let image: UIImage = UIImage(named: "Snowman.png")!
        layer.contents = image.cgImage
    }
    */
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        //draw a thick red circle
        ctx.setLineWidth(10)
        ctx.setStrokeColor(UIColor.red.cgColor)
        //圆被切断了
        //尽管我们没有用`masksToBounds`属性，绘制的那个圆仍然沿边界被裁剪了。这是因为当你使用CALayerDelegate绘制寄宿图的时候，并没有对超出边界外的内容提供绘制支持
        ctx.strokeEllipse(in: layer.bounds)
    }
    
    //注：除非你创建了一个单独的图层，你几乎没有机会用到CALayerDelegate协议。因为当UIView创建了它的宿主图层时，它就会自动地把图层的delegate设置为它自己，并提供了一个`-displayLayer:`的实现
    //当使用寄宿了视图的图层的时候，你也不必实现`-displayLayer:`和`-drawLayer:inContext:`方法来绘制你的寄宿图。通常做法是实现UIView的`-drawRect:`方法，UIView就会帮你做完剩下的工作，包括在需要重绘的时候调用`-display`方法
}
