//
//  DemoContentsCenterVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoContentsCenterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "寄宿图::layer.contentsCenter"
        
        let scrollView: UIScrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = UIColor.red
        self.view.addSubview(scrollView)
        
        // ==================================================================
        //                         原理说明
        // ==================================================================
        let size = CGSize.scaleSize(fixWidth: UIScreen.main.bounds.size.width, forSize: CGSizeMake(1252, 518))
        let frame = CGRectMake(0, 10, size.width, size.height)
        let showImagView1 = UIImageView(frame: frame)
        showImagView1.image = UIImage(named: "2.9.png")
        scrollView.addSubview(showImagView1)
        
        let size2 = CGSize.scaleSize(fixWidth: UIScreen.main.bounds.size.width, forSize: CGSizeMake(1208, 618))
        let frame2 = CGRectMake(0, showImagView1.frame.maxY+10, size2.width, size2.height)
        let showImageView2 = UIImageView(frame: frame2)
        showImageView2.image = UIImage(named: "2.10.png")
        scrollView.addSubview(showImageView2)
    
        // ==================================================================
        //                    layer.contentsCenter
        // ==================================================================
        //`contentsCenter`其实是一个CGRect，它定义了图层中的可拉伸区域和一个固定的边框
        //默认情况下，`contentsCenter`是{0, 0, 1, 1}，这意味着如果layer的大小改变了，那么寄宿图将会根据 contentsGravity 均匀地拉伸开
        //但是如果我们减小contentCenter尺寸，会在图片的周围创造一个边框
        //这意味着我们可以随意重设尺寸，边框仍然会是连续的
        //它工作起来的效果和UIImage里的-resizableImageWithCapInsets: 方法效果非常类似，但是它可以运用到任何寄宿图，甚至包括在Core Graphics运行时绘制的图形
        let image: UIImage = UIImage(named: "Button.png")!
        let frame1 = CGRectMake(5, showImageView2.frame.maxY+10, UIScreen.main.bounds.size.width-20, 50)
        let button1: UIView = UIView(frame: frame1)
        scrollView.addSubview(button1)
        
        let button2: UIView = UIView(frame: CGRectMake(frame1.midX-30, frame1.maxY + 10, 60, 400))
        scrollView.addSubview(button2)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, button2.frame.maxY)
        
        self.addStretchableImage(image: image, rect: CGRectMake(0.25, 0.25, 0.5, 0.5), layer: button1.layer)
        self.addStretchableImage(image: image, rect: CGRectMake(0.25, 0.25, 0.25, 0.25), layer: button2.layer)
    }
    
    func addStretchableImage(image: UIImage, rect: CGRect, layer: CALayer) {
        //set image
        layer.contents = image.cgImage
        layer.contentsScale = UIScreen.main.scale // 一定不要忘记设置scale! 在iPhone1，此值为3.0，即一个逻辑点=3像素点
        
        //set contentsCenter
        layer.contentsCenter = rect
        
        //注：contentsCenter的另一个很酷的特性就是，它可以在Interface Builder里面配置，根本不用写代码
        //XIB中有一个Stretching选项用于设置x, y, width, height
    }
}
