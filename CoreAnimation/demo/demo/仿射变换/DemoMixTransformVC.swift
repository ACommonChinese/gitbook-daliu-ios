//
//  DemoMixTransformVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/29.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoMixTransformVC: UIViewController {
    private let layerView: UIView = UIView()
    private var flag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let image: UIImage = UIImage(named: "Snowman")!
        
        /**
         Core Graphics提供了一系列的函数可以在一个变换的基础上做更深层次的变换，如果做一个既要*缩放*又要*旋转*的变换，这就会非常有用了。例如下面几个函数：

             CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
             CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
             CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)

         当操纵一个变换的时候，初始生成一个什么都不做的变换很重要--也就是创建一个`CGAffineTransform`类型的空值，矩阵论中称作*单位矩阵*，Core Graphics同样也提供了一个方便的常量：

             CGAffineTransformIdentity

         最后，如果需要混合两个已经存在的变换矩阵，就可以使用如下方法，在两个变换的基础上创建一个新的变换：

             CGAffineTransformConcat(CGAffineTransform t1, CGAffineTransform t2);

         我们来用这些函数组合一个更加复杂的变换，先缩小50%，再旋转30度，最后向右移动200个像素
         */
        layerView.frame = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layerView.layer.contents = image.cgImage
        self.view.addSubview(layerView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flag {
            UIView.animate(withDuration: 1.25) {
                var transform: CGAffineTransform = CGAffineTransform.identity //create a new transform
                //transform.scaledBy 方法返回一个新的 CGAffineTransform 对象
                //You use this function to create a new affine transformation matrix by adding scaling values to an existing affine transform.
                transform = transform.scaledBy(x: 0.5, y: 0.5) //scale by 50%
                transform = transform.rotated(by: CGFloat.pi/180*30) //rotate by 30 degrees
                transform = transform.translatedBy(x: 200, y: 0)
                //apply transform to layer
                self.layerView.layer.setAffineTransform(transform)
            }
        } else {
            UIView.animate(withDuration: 1.25) {
                self.layerView.layer.transform = CGAffineTransform.identity
            }
        }
    }
}
