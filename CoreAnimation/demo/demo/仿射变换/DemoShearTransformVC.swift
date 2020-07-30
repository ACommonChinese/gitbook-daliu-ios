//
//  DemoShearTransformVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/30.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoShearTransformVC: UIViewController {
    private let layerView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        /**
         Core Graphics为你提供了计算变换矩阵的一些方法，所以很少需要直接设置`CGAffineTransform`的值。除非需要创建一个*斜切*的变换，Core Graphics并没有提供直接的函数
         
         旋转, 缩放和平移是常见的仿射变换的三种形式
         - 旋转: CGAffineTransformMakeRotation(CGFloat angle)
         - 缩放: CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
         - 平移: CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
         
         斜切变换是放射变换的第四种类型, 较上述三种不常用
         */
        let image: UIImage = UIImage(named: "Snowman")!
        
        layerView.frame = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layerView.layer.contents = image.cgImage
        self.view.addSubview(layerView)
        
        self.layerView.layer.setAffineTransform(self.getShearTransform(x: 1, y: 0))
    }
    
    func getShearTransform(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        var transform: CGAffineTransform = CGAffineTransform.identity
        transform.c = -x
        transform.b = y

        return transform
    }
}
