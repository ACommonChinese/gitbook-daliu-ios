//
//  DemoCornerRadiusVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoCornerRadiusVC: UIViewController {
    let layerView1: UIView    = UIView(frame: CGRectMake(40, 150, UIScreen.main.bounds.size.width - 80, 200))
    let layerView1Sub: UIView = UIView(frame: CGRectMake(-30, -30, 100, 100))
    let layerView2: UIView    = UIView(frame: CGRectMake(40, 400, UIScreen.main.bounds.size.width - 80, 200))
    let layerView2Sub: UIView = UIView(frame: CGRectMake(-30, -30, 100, 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        /**
         CALayer有一个叫做`conrnerRadius`的属性控制着图层角的曲率。它是一个浮点数，默认为0（为0的时候就是直角），但是你可以把它设置成任意值。默认情况下，这个曲率值只影响背景颜色而不影响背景图片或是子图层。不过，如果把`masksToBounds`设置成YES的话，图层里面的所有东西都会被截取
         */
        layerView1.backgroundColor = UIColor.white
        layerView2.backgroundColor = UIColor.white
        layerView1Sub.backgroundColor = UIColor.red
        layerView2Sub.backgroundColor = UIColor.red
        self.view.addSubview(layerView1)
        self.view.addSubview(layerView2)
        self.layerView1.addSubview(layerView1Sub)
        self.layerView2.addSubview(layerView2Sub)
        
        //set the corner radius on our layers
        self.layerView1.layer.cornerRadius = 20.0;
        self.layerView2.layer.cornerRadius = 20.0;

        //enable clipping on the second layer
        self.layerView2.layer.masksToBounds = true;
    }
}
