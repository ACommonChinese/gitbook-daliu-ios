//
//  DemoSimpleRotation.swift
//  demo
//
//  Created by 刘威振 on 2020/7/29.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoSimpleRotationVC: UIViewController {
    private let layerView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        /**
        - 旋转: CGAffineTransformMakeRotation(CGFloat angle)
        - 缩放: CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
        - 平移: CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
         
         `UIView`可以通过设置`transform(CGAffineTransform)`属性做变换，但实际上它只是封装了内部图层的变换
         `CALayer`同样也有一个`transform`属性，但它的类型是`CATransform3D`，而不是`CGAffineTransform`
         `CALayer`对应于`UIView`的`transform`属性叫做`affineTransform`
         
         下面示例子使用`affineTransform`对图层做了45度顺时针旋转
         */
        let image: UIImage = UIImage(named: "Snowman")!
        
        layerView.frame = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layerView.layer.contents = image.cgImage
        self.view.addSubview(layerView)
        
        //rotate the layer 45 degrees
        let transform: CGAffineTransform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi/4))
        layerView.layer.setAffineTransform(transform)
    }
}
