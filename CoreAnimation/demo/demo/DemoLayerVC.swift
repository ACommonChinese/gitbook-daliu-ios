//
//  DemoLayerVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoLayerVC: UIViewController {
    var layerView: UIView = UIView(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 200, height: 200)))
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.title = DLTitle.Layer.rawValue
        
        self.layerView.center = self.view.center
        self.layerView.backgroundColor = UIColor.white
        self.view.addSubview(self.layerView)
        
        // 职责分离
        // UIView处理手势点击
        // CALayer负责底层UI绘制显示
        let blueLayer: CALayer = CALayer()
        blueLayer.frame = CGRect(origin: CGPoint.init(x: 50, y: 50), size: CGSize.init(width: 100, height: 100))
        blueLayer.backgroundColor = UIColor.blue.cgColor
        self.layerView.layer.addSublayer(blueLayer) // 往view的layer上添加一个laye
    }
}
