//
//  Demo3DTheoryVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/31.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class Demo3DTheoryVC: UIViewController {
    let layerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        printIdentifyInfo()
        setupUI()
    }
    
    func printIdentifyInfo() {
        let transform = CATransform3DIdentity
        //https://developer.apple.com/documentation/quartzcore/catransform3didentity
        //The identity transform: [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
        //当CATransform3DIsIdentity=YES的时候，说明CATransform3D是个单位矩阵，此时不进行变换，当为NO时，进行变换。CATransform3DIsIdentity也是一个常量，为单位矩阵，值是[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
        /**
         [1 0 0 0
          0 1 0 0
          0 0 1 0
          0 0 0 1]
         */
        print(transform.m11) //1
        print(transform.m12) //0
        print(transform.m13) //0
        print(transform.m14) //0
        
        print(transform.m21) //0
        print(transform.m22) //1
        print(transform.m23) //0
        print(transform.m24) //0
        
        print(transform.m31) //0
        print(transform.m32) //0
        print(transform.m33) //1
        print(transform.m34) //0
        
        print(transform.m41) //0
        print(transform.m42) //0
        print(transform.m43) //0
        print(transform.m44) //1
    }
    
    func setupUI() {
        let image: UIImage = UIImage(named: "Snowman")!
        
        layerView.frame = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layerView.layer.contents = image.cgImage
        self.view.addSubview(layerView)
        
        /**
         CATransform3D结构是一个4*4的矩阵, CATransform3D的图层变换是以锚点（anchorPoint）的位置来进行
         https://juejin.im/entry/6844903558735724558
         ```
         struct CATransform3D
         {
           CGFloat m11, m12, m13, m14;
           CGFloat m21, m22, m23, m24;
           CGFloat m31, m32, m33, m34;
           CGFloat m41, m42, m43, m44;
         };
         typedef struct CATransform3D CATransform3D;

         struct CATransform3D
         {
           CGFloat m11（x缩放）, m12, m13, m14;
           CGFloat m21, m22（y缩放）, m23, m24;
           CGFloat m31, m32, m33（z缩放）, m34（透视效果，要有角度才会显示）;
           CGFloat m41（x平移）, m42（y平移）, m43（z平移）, m44;
         };
         ```
         
         x` = x m11 + y m12 + z m13 + m14
         y` = x m21 + y m22 + y m23 + m24
         z` = x m31 + y m32 + z m33 + m34
         平移相关: m41  m42  m43  m44
         */
        
        let info: UILabel = UILabel.init(frame: CGRectMake(0, layerView.frame.maxY + 20, getScreenWidth(), 30))
        info.textAlignment = .center
        info.text = "点击 -- 宽缩小1/2, 高缩小1/2, 向上平移100, 恢复"
        self.view.addSubview(info)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var transform = CATransform3D.init()
        // CATransform3DIdentity
        transform.m11 = 1.0
        transform.m22 = 1.0
        transform.m33 = 1.0
        transform.m44 = 1.0
        self.layerView.layer.transform = transform
        UIView.animate(withDuration: 1, animations: {
            transform.m11 = 0.5 // 宽缩小为1/2
            self.layerView.layer.transform = transform
        }) { (f) in
            UIView.animate(withDuration: 1, animations: {
                transform.m22 = 0.5 // 高缩小为1/2
                self.layerView.layer.transform = transform
            }) { (f) in
                UIView.animate(withDuration: 1, animations: {
                    transform.m42 = -100 // 向上平移100
                    self.layerView.layer.transform = transform
                }) { (f) in
                    UIView.animate(withDuration: 1, animations: {
                        self.layerView.layer.transform = CATransform3DIdentity // 恢复
                    }, completion: nil)
                }
            }
        }
    }
}
