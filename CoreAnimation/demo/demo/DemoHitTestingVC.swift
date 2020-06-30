//
//  DemoHitTestingVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoHitTestingVC: UIViewController {

    let blueLayer = CALayer()
    let layerView: UIView = UIView(frame: CGRectMake(0, 0, 200, 200))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        //`CALayer`对响应链一无所知，所以它不能直接处理触摸事件或者手势。
        // 但是它有一系列的方法帮你处理事件：`-containsPoint:`和`-hitTest:`
        //` -containsPoint: `接受一个在本图层坐标系下的`CGPoint`，如果这个点在图层范围内就返回`YES`
        //需要特别注意的是, 这个`-containsPoint:`方法要求接收的CGPoint的坐标系以本layer为准, 因此往往需要把触摸坐标转换成指定图层坐标系下的坐标
        //下面代码示例了使用`-containsPoint:`方法来判断是白色还是蓝色的图层被触摸了
        
        self.layerView.backgroundColor = UIColor.white
        self.layerView.center = self.view.center
        self.view.addSubview(self.layerView)
        
        self.blueLayer.frame = CGRectMake(50, 50, 100, 100)
        self.blueLayer.backgroundColor = UIColor.blue.cgColor
        self.layerView.layer.addSublayer(self.blueLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch position relative to main view
        guard let touch = touches.first else {
            return
        }
        var point: CGPoint = touch.location(in: self.view)
        //convert point to the white layer's coordinates
        point = self.layerView.layer.convert(point, from: self.view.layer)
        //get layer using containsPoint:
        if self.layerView.layer.contains(point) {
            //convert point to blueLayer’s coordinates
            point = self.blueLayer.convert(point, from: self.layerView.layer)
            if self.blueLayer.contains(point) {
                showAlert("Inside Blue Layer")
            } else {
                showAlert("Inside White Layer")
            }
        }
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default, handler: { (actionq) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
