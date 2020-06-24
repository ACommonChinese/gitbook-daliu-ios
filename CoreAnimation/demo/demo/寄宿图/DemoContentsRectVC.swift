//
//  DemoContentsRectVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

/// layer.contentsRect
class DemoContentsRectVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.title = "寄宿图::layer.contentsRect"

        //CALayer的`contentsRect`属性允许我们在图层边框里显示寄宿图的一个子域
        //它使用单位坐标，单位坐标指定在0到1之间，是一个相对值,它是相对于寄宿图的尺寸的
        
        //iOS使用了以下的坐标系统：
        //* 点 —— 在iOS和Mac OS中最常见的坐标体系。点就像是虚拟的像素，也被称作逻辑像素。在标准清晰度的设备上，一个点就是一个像素，但是在Retina设备上，一个点等于2*2个像素。iOS用点作为屏幕的坐标测算体系就是为了在Retina设备和普通设备上能有一致的视觉效果。
        //* 像素 —— 物理像素坐标并不会用来屏幕布局，但是它们在处理图片时仍然是相关的。UIImage可以识别屏幕分辨，并以点为单位指定其大小。但是一些底层的图片表示如CGImage就会使用像素，所以你要清楚在Retina设备和普通设备上，它们表现出来了不同的大小。
        //* 单位 —— 对于与图片大小或是图层边界相关的显示，单位坐标是一个方便的度量方式， 当大小改变的时候，也不需要再次调整。单位坐标在OpenGL这种纹理坐标系统中用得很多，Core Animation中也用到了单位坐标
        
        //`contentsRect`最有趣的用处之一是它能够使用*image sprites*（图片拼合）
        //需求：切割一个包含4个小图片的拼合图
        //思路很简单：像平常一样载入我们的大图，然后把它赋值给四个独立的图层的`contents`，然后设置每个图层的`contentsRect`来去掉我们不想显示的部分
        let image: UIImage = UIImage(named: "Sprites.png")!
        let imageView: UIImageView = UIImageView.init(image: image)
        imageView.frame = CGRectMake(10, 100, 100,  100)
        self.view.addSubview(imageView)
        
        let width: CGFloat = 150.0
        let height: CGFloat = 150.0
        let margin: CGFloat = 20.0
        let topLeft: UIView = UIView.init(frame: CGRectMake(margin, imageView.frame.maxY + 10, width, height))
        let topRight: UIView = UIView.init(frame: CGRectMake(topLeft.frame.maxX + margin, topLeft.frame.minY, width, height))
        let bottomLeft: UIView = UIView.init(frame: CGRectMake(margin, topLeft.frame.maxY + margin, width, height))
        let bottomRight: UIView = UIView.init(frame: CGRectMake(bottomLeft.frame.maxX + margin, bottomLeft.frame.minY, width, height))
        topLeft.backgroundColor = UIColor.cyan
        topRight.backgroundColor = UIColor.cyan
        bottomLeft.backgroundColor = UIColor.cyan
        bottomRight.backgroundColor = UIColor.cyan
        self.view.addSubview(topLeft)
        self.view.addSubview(topRight)
        self.view.addSubview(bottomLeft)
        self.view.addSubview(bottomRight)
        self.addSpriteImage(image: image, contentRect: CGRectMake(0, 0, 0.5, 0.5), toLayer: topLeft.layer)
        self.addSpriteImage(image: image, contentRect: CGRectMake(0.5, 0, 0.5, 0.5), toLayer: topRight.layer)
        self.addSpriteImage(image: image, contentRect: CGRectMake(0, 0.5, 0.5, 0.5), toLayer: bottomLeft.layer)
        self.addSpriteImage(image: image, contentRect: CGRectMake(0.5, 0.5, 0.5, 0.5), toLayer: bottomRight.layer)
    }
    
    //set image
    func addSpriteImage(image: UIImage, contentRect rect: CGRect, toLayer layer: CALayer) {
        layer.contents = image.cgImage
        layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layer.contentsRect = rect
    }
    
    // 有一个叫做LayerSprites的开源库（[https://github.com/nicklockwood/LayerSprites](https://github.com/nicklockwood/LayerSprites))，它能够读取Cocos2D格式中的拼合图并在普通的Core Animation层中显示出来
}
