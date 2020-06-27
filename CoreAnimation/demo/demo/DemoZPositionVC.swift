//
//  DemoZPositionVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/27.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoZPositionVC: UIViewController {
    let greenView = UIView(frame: CGRectMake(100, 100, 100, 100))
    let redViw = UIView(frame: CGRectMake(130, 130, 100, 100))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        greenView.backgroundColor = UIColor.green
        self.view.addSubview(greenView)
        
        redViw.backgroundColor = UIColor.red
        self.view.addSubview(redViw)
        
        let btn = UIButton(type: .system)
        btn.frame = CGRectMake(0, greenView.frame.maxY + 60, self.view.frame.size.width, 50)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("改变绿色视图zPosition", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.view.addSubview(btn)
        
        /**
        和`UIView`严格的二维坐标系不同，`CALayer`存在于一个三维空间当中。除了我们已经讨论过的`position`和`anchorPoint`属性之外，`CALayer`还有另外两个属性，`zPosition`和`anchorPointZ`，二者都是在Z轴上描述图层位置的浮点类型
         
        `zPosition`属性在大多数情况下其实并不常用。在第五章，我们将会涉及`CATransform3D`，你会知道如何在三维空间移动和旋转图层，除了做变换之外，`zPosition`最实用的功能就是改变图层的*显示顺序*了
         
         通常，图层是根据它们子图层的`sublayers`出现的顺序来绘制的，这就是所谓的*画家的算法*--就像一个画家在墙上作画--后被绘制上的图层将会遮盖住之前的图层，但是通过增加图层的`zPosition`，就可以把图层向相机方向前置，于是它就在所有其他图层的前面了, （或者至少是小于它的`zPosition`值的图层的前面）
         这里所谓的“相机”实际上是相对于用户是视角，这里和iPhone背后的内置相机没任何关系
         
         下面代码有两个视图, 縁色视图在红色视图的下面, 通过改变绿色视图的zPosition, 就可以让绿色视图前置
        */
    }
    
    @objc
    func btnClick() {
        // zPosition并不需要增加太多，视图都非常地薄，所以给`zPosition`提高一个像素就可以让绿色视图前置，当然0.1或者0.0001也能够做到，但是最好不要这样，因为浮点类型四舍五入的计算可能会造成一些不便的麻烦。
        print("redView.layer.zPosition: \(self.redViw.layer.zPosition)") // 0
        print("greenView.layer.zPosition: \(self.greenView.layer.zPosition)") // 0
        self.redViw.layer.zPosition = 2.0;
        self.greenView.layer.zPosition = 3.0;
        print("redView.layer.zPosition: \(self.redViw.layer.zPosition)") // 2
        print("greenView.layer.zPosition: \(self.greenView.layer.zPosition)") // 3
        
        // 由于blueView的zPostion是0, 所以, 它在最下面
        let blueView = UIView(frame: CGRectMake(160, 160, 100, 100))
        blueView.backgroundColor = UIColor.blue
        self.view.addSubview(blueView)
        
        /**
         greenView 最上面 zPosition 3
         redView 中间 zPostion = 2
         blueView 最下面 zPostion = 0
         */
    }
}
