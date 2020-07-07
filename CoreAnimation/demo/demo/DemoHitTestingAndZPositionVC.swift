//
//  DemoHitTestingAndZPositionVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/1.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoHitTestingAndZPositionVC: UIViewController {
    let redView: UIView   = UIView()
    let greenView: UIView = UIView()
    let blueView: UIView  = UIView()
    
    let grayView: UIView = UIView()
    let redView2: UIView = UIView()
    let greenView2: UIView = UIView()
    let blueView2: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false;
        
        // 红 绿 蓝 视图
        self.view.backgroundColor = UIColor.white
        redView.backgroundColor   = UIColor.red
        greenView.backgroundColor = UIColor.green
        blueView.backgroundColor  = UIColor.blue
        self.redView.frame        = CGRectMake(20, 20, view.bounds.size.width - 40, 200)
        self.greenView.frame      = CGRectMake(30, 20, redView.frame.width-30, redView.frame.size.height-30)
        self.blueView.frame       = CGRectMake(30, 20, greenView.frame.width-20, greenView.frame.height - 10)
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        self.view.addSubview(blueView)
        
        // 改变zpostion的按钮
        let btn = UIButton.init(type: .system)
        btn.frame = CGRectMake(0, redView.frame.maxY + 20, self.view.frame.size.width, 50)
        btn.setTitle("点击按钮改变下方视图的zPosition", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(btn)
        
        // 灰色视图
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch position
        guard let touch = touches.first else {
            return
        }
        let point: CGPoint = touch.location(in: self.view)
        //get touch layer
        let layer: CALayer? = self.redView.layer.hitTest(point)
        guard let targetLayer = layer else {
            return
        }
        if targetLayer == self.blueView.layer {
            showAlert("Inside Blue View")
        }
        if targetLayer == self.greenView.layer {
            showAlert("Inside Green View")
        }
        if targetLayer == self.redView.layer {
            showAlert("Inside Red View")
        }
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (actionq) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func btnClick() {
        blueView.layer.zPosition = 1;
    }
}

class GrayView : UIView {
    
}
