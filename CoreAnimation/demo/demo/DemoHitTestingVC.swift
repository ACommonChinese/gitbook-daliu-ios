//
//  DemoHitTestingVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoHitTestingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        //`CALayer`对响应链一无所知，所以它不能直接处理触摸事件或者手势。
        // 但是它有一系列的方法帮你处理事件：`-containsPoint:`和`-hitTest:`
        //` -containsPoint: `接受一个在本图层坐标系下的`CGPoint`，如果这个点在图层范围内就返回`YES`
        //需要特别注意的是, 这个`-containsPoint:`方法要求接收的CGPoint的坐标系以本layer为准, 因此往往需要把触摸坐标转换成指定图层坐标系下的坐标
        //下面代码示例了使用`-containsPoint:`方法来判断是白色还是蓝色的图层被触摸了
    }
    
//    func demoHit(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}
