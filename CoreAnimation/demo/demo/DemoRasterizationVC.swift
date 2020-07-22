//
//  DemoRasterizationVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/21.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoRasterizationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        let containerView = UIView.init(frame: UIScreen.main.bounds)
        containerView.alpha = 0.5
        self.view.addSubview(containerView)

        let length: CGFloat = 150.0
        let originX = (UIScreen.main.bounds.width - length) / 2.0
        
        //create opaque button
        let button1 = customButton(rect: CGRect.init(x: originX, y: 160, width: length, height: length))
        self.view.addSubview(button1)
        
        //create translucent button
        let button2 = customButton(rect: CGRect.init(x: button1.frame.minX, y: button1.frame.maxY + 40, width: length, height: length))
        button2.alpha = 0.5
        self.view.addSubview(button2)
        
        //enable rasterization for the translucent button
        button2.layer.shouldRasterize = true
        button2.layer.rasterizationScale = UIScreen.main.scale
    }
    
    //4-视觉效果 试验未成功
    func customButton(rect: CGRect) -> UIButton {
        //create button
        // var frame = CGRect.init(x: 0, y: 0, width: 150, height: 150)
        var frame = rect
        let button: UIButton = UIButton.init(frame: frame)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10.0
        
        //add label
        frame = CGRect.init(x: 20, y: 10, width: frame.width-40, height: 30)
        let label = UILabel.init(frame: frame)
        label.text = "Hello World"
        label.backgroundColor = UIColor.white
        //label.alpha = 0.5
        label.textAlignment = .center
        button.addSubview(label)
        return button
    }
}
