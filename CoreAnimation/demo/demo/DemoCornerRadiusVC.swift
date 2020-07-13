//
//  DemoCornerRadiusVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoCornerRadiusVC: UIViewController {
    let scrollView: UIScrollView = UIScrollView(frame: UIScreen.main.bounds)
    let layerView1: UIView    = UIView(frame: CGRectMake(40, 50, UIScreen.main.bounds.size.width - 80, 200))
    let layerView1Sub: UIView = UIView(frame: CGRectMake(-30, -30, 100, 100))
    let layerView2: UIView    = UIView(frame: CGRectMake(40, 280, UIScreen.main.bounds.size.width - 80, 200))
    let layerView2Sub: UIView = UIView(frame: CGRectMake(-30, -30, 100, 100))
    let imgLayerView: UIView  = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = UIColor.gray
        
        /**
         CALayer有一个叫做`conrnerRadius`的属性控制着图层角的曲率。它是一个浮点数，默认为0（为0的时候就是直角），但是你可以把它设置成任意值。默认情况下，这个曲率值只影响背景颜色而不影响背景图片或是子图层。不过，如果把`masksToBounds`设置成YES的话，图层里面的所有东西都会被截取
         */
        layerView1.backgroundColor = UIColor.white
        layerView2.backgroundColor = UIColor.white
        layerView1Sub.backgroundColor = UIColor.red
        layerView2Sub.backgroundColor = UIColor.red
        self.scrollView.addSubview(layerView1)
        self.scrollView.addSubview(layerView2)
        self.layerView1.addSubview(layerView1Sub)
        self.layerView2.addSubview(layerView2Sub)
        
        //set the corner radius on our layers
        self.layerView1.layer.cornerRadius = 20.0;
        self.layerView1.layer.borderWidth  = 5.0
        self.layerView2.layer.cornerRadius = 20.0;
        self.layerView2.layer.borderWidth  = 5.0

        //enable clipping on the second layer
        self.layerView2.layer.masksToBounds = true;
        
        //注意边框并不会考虑寄宿图或子图层的形状，如果图层的子图层超过了边界，或者是寄宿图在透明区域有一个透明蒙板，边框仍然会沿着图层的边界绘制出来
        //边框是跟随图层的边界变化的，而不是图层里面的内容
        let image: UIImage = UIImage(named: "Snowman.png")!
        self.imgLayerView.frame = CGRectMake(0, layerView2.frame.maxY + 50, 150, 150)
        var center = self.imgLayerView.center
        center.x = UIScreen.main.bounds.midX
        self.imgLayerView.center = center
        self.imgLayerView.layer.contents = image.cgImage
        self.imgLayerView.layer.cornerRadius = 20.0
        self.imgLayerView.layer.borderWidth = 5.0
        self.imgLayerView.layer.contentsScale = image.scale
        self.imgLayerView.layer.contentsGravity = .resizeAspectFill
        self.scrollView.addSubview(self.imgLayerView)
        
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.bounds.width, height: self.imgLayerView.frame.maxY + 10)
    }
    
    @objc
    func btnClick() {
        
    }
}
