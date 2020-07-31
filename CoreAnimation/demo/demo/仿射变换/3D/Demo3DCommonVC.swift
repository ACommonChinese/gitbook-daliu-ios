//
//  Demo3DCommonVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/31.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class Demo3DCommonVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         和`CGAffineTransform`矩阵类似，Core Animation提供了一系列的方法用来创建和组合`CATransform3D`类型的矩阵，
         但是3D的平移和缩放多出了一个`z`参数，并且旋转函数除了`angle`之外多出了`x`,`y`,`z`三个参数，分别决定了每个坐标轴方向上的旋转：
         ```
         CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
         CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
         CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
         ```
         绕Z轴的旋转等同于之前二维空间的仿射旋转，但是绕X轴和Y轴的旋转就突破了屏幕的二维空间，并且在用户视角看来发生了倾斜
         */
    }
}
