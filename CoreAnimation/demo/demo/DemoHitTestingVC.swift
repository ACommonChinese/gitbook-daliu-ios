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
    
    /** 使用containsPoint判断被点击的图层
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
    */
    
    // 使用hitTest判断被点击的图层
    // -hitTest: 方法同样接受一个 CGPoint 类型参数，它返回图层本身，或者包含这个坐标点的叶子节点图层。
    // 这意味着不再需要像使用 - containsPoint: 那样，人工地在每个子图层变换或者测试点击的坐标。如果这个点在最外面图层的范围之外，则返回nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //get touch position
        guard let touch = touches.first else {
            return
        }
        let point: CGPoint = touch.location(in: self.view)
        
        //get touch layer
        //self.layerView: 白色的视图
        let layer: CALayer? = self.layerView.layer.hitTest(point)
        // 如果这个点在layerView的子图层上, 会返回这个子图层, 如果点不在叶子图层上, 会返回自已(同理, 如果子图层又有子图层, 而点又在这个子图层的子图层了, 会返回最后的子图层)
        /**
         From Apple:
         func hitTest(_ p: CGPoint) -> CALayer?
         Returns the farthest descendant of the receiver in the layer hierarchy (including itself) that contains the specified point.\
         参数: p: CGPoint A point in the coordinate system of the receiver's superlayer.
         返回值CALayer: The layer that contains thePoint or nil if the point lies outside the receiver’s bounds rectangle.
         */
        
        //get layer using hitTest
        if let bLayer = layer {
            if bLayer == self.blueLayer  {
                showAlert("Inside Blue Layer")
            }
            else if (bLayer == self.layerView.layer) {
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
    
    // 注意当调用图层的 -hitTest: 方法时，测算的顺序严格依赖于图层树当中的图层顺序(和UIView处理事件类似)。即寻找顺序为 叶子图层 > 中间的子图层... > 自己
    // 之前提到的 zPosition 属性可以看起来改变屏幕上图层的显示顺序，但不能改变事件传递的顺序。
    // 这意味着如果改变了图层的z轴顺序，你会发现将不能够检测到最前方的视图点击事件，这是因为被另一个图层遮盖住了，虽然它的 zPosition 值较小，但是在图层树中的顺序靠前
}
