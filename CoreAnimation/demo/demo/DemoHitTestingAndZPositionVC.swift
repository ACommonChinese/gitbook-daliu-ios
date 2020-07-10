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
        self.redView.frame        = CGRectMake(10, 10, 200, 200)
        self.greenView.frame      = CGRectMake(60, 60, 200, 200)
        self.blueView.frame       = CGRectMake(110, 110, 200, 200)
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        self.view.addSubview(blueView)
        self.attachLineForGreenView()
        
        // 改变zpostion的按钮
        let btn = UIButton.init(type: .system)
        btn.frame = CGRectMake(0, blueView.frame.maxY + 20, self.view.frame.size.width, 50)
        btn.setTitle("greenView.layer.zPosition = 1", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(btn)
        
        let restoreBtn = UIButton.init(type: .system)
        restoreBtn.frame = CGRectMake(0, btn.frame.maxY + 20, self.view.frame.size.width, 50)
        restoreBtn.setTitle("greenView.layer.zPosition = 0", for: .normal)
        restoreBtn.addTarget(self, action: #selector(restoreBtnClick), for: .touchUpInside)
        restoreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        restoreBtn.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(restoreBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch position
        guard let touch = touches.first else {
            return
        }
        let point: CGPoint = touch.location(in: self.view)
        //get touch layer
        //let layer: CALayer? = self.redView.layer.hitTest(point)
        var layer: CALayer? = self.blueView.layer.hitTest(point)
        if nil == layer {
            layer = self.greenView.layer.hitTest(point)
            if nil == layer {
                layer = self.redView.layer.hitTest(point)
            }
        }
        guard let _ = layer else {
            showAlert("在视图外")
            return
        }
        if layer == self.blueView.layer {
            showAlert("Inside Blue View")
        }
        if layer == self.greenView.layer {
            showAlert("Inside Green View")
        }
        if layer == self.redView.layer {
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
        greenView.layer.zPosition = 1
    }
    
    @objc
    func restoreBtnClick() {
        greenView.layer.zPosition = 0
    }
    
    //添加辅助线方便识别
    func attachLineForGreenView() {
        let hLine = UIView(frame: CGRectMake(50, 50, greenView.frame.size.width-50, 2))
        hLine.backgroundColor = UIColor.blue
        let vLine = UIView(frame: CGRectMake(50, 50, 2, greenView.frame.size.height - 50))
        vLine.backgroundColor = UIColor.blue
        greenView.addSubview(hLine)
        greenView.addSubview(vLine)
    }
}
