//
//  DemoContentsVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoContentsVC: UIViewController {
    var layerView: UIView = UIView(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 200, height: 200)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.title = DLTitle.Contents.rawValue
        var center: CGPoint = self.view.center
        center.y = center.y - 100
        self.layerView.center = center
        self.layerView.backgroundColor = UIColor.white
        self.view.addSubview(self.layerView)
        
        //CALayer的contents属性：
        //open var contents: Any?
        //load an image
        let image: UIImage = UIImage(named: "Snowman.png")!
        //add it directly to our view's layer
        self.layerView.layer.contents = image.cgImage
        
        // ======================================================================
        //            contentsGravity(contentMode) & contentsScale
        // ======================================================================
        //由于加载的图片是200*280  2x(400*560), 并不是正方形，而layerView是正方形200*200, 默认显示起来图片偏胖
        //undistort the image
        // self.layerView.contentMode = UIView.ContentMode.scaleAspectFit
        //UIView大多数视觉相关的属性比如`contentMode`，对这些属性的操作其实是对对应图层的操作
        //CALayer与`contentMode`对应的属性叫做`contentsGravity`：
        //self.layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        //contentsGravity, 的目的是为了决定内容在图层的边界中怎么对齐
        /**
        center: 居中，不拉伸，根据contentScale像素比显示
        top:
        bottom:
        left:
        right:
        topLeft:
        topRight:
        bottomLeft:
        bottomRight:
        resize:
        resizeAspect: 等比拉伸以适应视图边界
        resizeAspectFill: 默认，图片会填充视图
         */
        
        self.layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        print("image.scale: \(image.scale)") // 2.0，因为项目中图片只有@2x， 没有@3x
        //和UIImage不同，CGImage没有拉伸的概念。当我们使用UIImage类去读取我们的雪人图片的时候，它读取了高质量的Retina版本的图片。但是当我们用CGImage来设置我们的图层的内容时，拉伸这个因素在转换的时候就丢失了。不过我们可以通过手动设置`contentsScale`来修复这个问题
        self.layerView.layer.contentsScale = image.scale
        //self.layerView.layer.contentsScale = UIScreen.main.scale
        print("screen scale: \(UIScreen.main.scale)") // 3.0 会真实的反映像素比
        // ### contentsScale
        //`contentsScale`属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数, UIView有一个类似功能但是非常少用到的`contentScaleFactor`属性
        //当用代码的方式来处理寄宿图的时候，一定要记住要手动的设置图层的`contentsScale`属性，否则，你的图片在Retina设备上就显示得不正确啦。代码如下
        //layer.contentsScale = [UIScreen mainScreen].scale;
        //比如设置了layer.contentsScale=3, 那么一个逻辑点对应的是3*3真实像素

        // ======================================================================
        //                          masksToBounds
        // ======================================================================
        //UIView有一个叫做`clipsToBounds`的属性可以用来决定是否显示超出边界的内容，CALayer对应的属性叫做`masksToBounds`
        //self.layerView.clipsToBounds = true
        self.layerView.layer.masksToBounds = true
        // self.layerView.layer.contentsRect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 0.5, height: 0.5))
        
        // ======================================================================
        //                          contentsRect
        // ======================================================================
        let contentsRectBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        contentsRectBtn.frame = CGRect.init(origin: CGPoint.init(x: 0, y: self.layerView.frame.maxY + 60), size: CGSize.init(width: self.view.bounds.size.width, height: 40))
        contentsRectBtn.setTitle("layer.contentsRect 裁剪", for: .normal)
        contentsRectBtn.setTitleColor(UIColor.white, for: .normal)
        contentsRectBtn.addTarget(self, action: #selector(contentsRectBtnClick), for: .touchUpInside)
        self.view.addSubview(contentsRectBtn)
        
        // ======================================================================
        //                          contentsCenter
        // ======================================================================
        let contentsCenterBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        contentsCenterBtn.frame = CGRect.init(origin: CGPoint.init(x: 0, y: contentsRectBtn.frame.maxY + 10), size: CGSize.init(width: self.view.bounds.size.width, height: 40))
        contentsCenterBtn.setTitle("layer.contentsRect 拉伸区域", for: .normal)
        contentsCenterBtn.setTitleColor(UIColor.white, for: .normal)
        contentsCenterBtn.addTarget(self, action: #selector(contentsCenterBtnClick), for: .touchUpInside)
        self.view.addSubview(contentsCenterBtn)
        
        // ======================================================================
        //                        drawLayer绘制寄宿图
        // ======================================================================
        let drawRectBtn: UIButton = UIButton.init(type: .system)
        drawRectBtn.frame = CGRectMake(0, contentsCenterBtn.frame.maxY+10, self.view.bounds.size.width, 40)
        drawRectBtn.setTitle("drawRect", for: .normal)
        drawRectBtn.setTitleColor(UIColor.white, for: .normal)
        drawRectBtn.addTarget(self, action: #selector(drawRectBtnClick), for: .touchUpInside)
        self.view.addSubview(drawRectBtn)
    }
    
    @objc
    func contentsRectBtnClick() {
        self.navigationController?.pushViewController(DemoContentsRectVC(), animated: true)
    }
    
    @objc
    func contentsCenterBtnClick() {
        self.navigationController?.pushViewController(DemoContentsCenterVC(), animated: true)
    }
    
    @objc
    func drawRectBtnClick() {
        self.navigationController?.pushViewController(DemoDrawRectVC(), animated: true)
    }
}
