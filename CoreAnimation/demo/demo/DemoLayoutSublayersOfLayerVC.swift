//
//  DemoLayoutSublayersOfLayerVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/9.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class CustomLayerView : UIView {
    override func layoutSublayers(of layer: CALayer) {
        layer.backgroundColor = UIColor.green.cgColor
        let subLayer = layer.sublayers!.first!
        var frame = layer.frame
        frame.origin.x = 10
        frame.origin.y = 10
        frame.size.width = frame.size.width - 20
        frame.size.height = frame.size.height - 20
        subLayer.frame = frame
    }
}

class DemoLayoutSublayersOfLayerVC: UIViewController {
    /**
     对象创建, 要初始化变量, 此处被调用
     */
    var layerView: CustomLayerView = {
        print("here 1")
        let view = CustomLayerView(frame: CGRect.init(x: 30, y: 100, width: 200, height: 200))
        view.backgroundColor = UIColor.green
        return view
    }()
    
    /**
     对象创建, 要初始化变量, 此处被调用
     */
    var redView: UIView = {
        print("here 2")
        let redV = UIView(frame: CGRectMake(20, 20, 100, 100))
        redV.backgroundColor = UIColor.red
        
        return redV
    }()
    
    /**
     静态的这种代码块并不会随着Class的加载而被和
     */
    static var str: String = {
        print("here 0")
        return "hello"
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.layerView)
        self.layerView.addSubview(self.redView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var frame:CGRect = self.layerView.frame
        frame.size.width = frame.size.width + 2
        frame.size.height = frame.size.height + 10
        self.layerView.frame = frame
    }
}
