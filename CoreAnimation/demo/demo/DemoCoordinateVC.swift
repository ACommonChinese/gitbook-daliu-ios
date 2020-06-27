//
//  DemoCoordinateVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoCoordinateVC: UIViewController {
    var redView: UIView = UIView()
    var greenView: UIView = UIView()
    var purpleView: UIView = UIView()
    var cyanView: UIView = UIView()
    var yellowView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.view.backgroundColor = UIColor.white
        self.redView.backgroundColor = UIColor.red
        self.greenView.backgroundColor = UIColor.green
        self.purpleView.backgroundColor = UIColor.purple
        self.cyanView.backgroundColor = UIColor.cyan
        self.yellowView.backgroundColor = UIColor.yellow
        
        
        //坐标系-bounds
        let label = UILabel(frame: CGRectMake(10, 10, self.view.bounds.size.width-20, 30))
        
        label.text = "========= 坐标系 ========= "
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        var rect = label.frame
        
        let button = UIButton(type: .system)
        rect.origin.y = rect.maxY + 10
        button.frame = rect
        button.setTitle("改变父bounds", for: .normal)
        button.addTarget(self, action: #selector(changeBounds), for: .touchUpInside)
        self.view.addSubview(button)
        
        rect.origin.y = button.frame.maxY + 10
        rect.size.height = 100
        redView.frame = rect
        redView.backgroundColor = UIColor.red
        self.view.addSubview(redView)
        
        greenView.frame = redView.bounds
        greenView.backgroundColor = UIColor.green
        redView.addSubview(greenView)
        
        // ------------------------------------------------------------------
        let label2 = UILabel(frame: CGRectMake(10, redView.frame.maxY + 30, redView.frame.size.width, 20))
        label2.text = "=========  坐标系转换 ========= "
        label2.textAlignment = NSTextAlignment.center
        self.view.addSubview(label2)
        
        self.purpleView.frame = CGRectMake(20, label2.frame.maxY + 10, 300, 300)
        self.cyanView.frame = CGRectMake(20, 20, 200, 200)
        self.yellowView.frame = CGRectMake(60, 60, 100, 100)
        self.view.addSubview(self.purpleView)
        self.purpleView.addSubview(self.cyanView)
        self.cyanView.addSubview(self.yellowView)
        
        printCoordinateInfo()
    }
    
    @objc
    func changeBounds() {
        //图层在图层树当中也是相对于父图层按层级关系放置，一个图层的`position`依赖于它父图层的`bounds`，
        //如果父图层发生了移动，它的所有子图层也会跟着移动
        var bounds = redView.bounds
        bounds.origin.y = -10
        bounds.origin.x = -5
        redView.layer.bounds = bounds // 此句代码和下面的代码有同样的效果
        // redView.bounds = bounds
    }
    
    func printCoordinateInfo() {
        printFrame(purpleView.frame)    // 20.0, 250.0, 300.0, 300.0
        printFrame(cyanView.frame)      // 20.0, 20.0, 200.0, 200.0
        printFrame(yellowView.frame)    // 60.0, 60.0, 100.0, 100.0
        
        print("1. ------------------------------------------------------")
        print("cyanView 的左上角 相对于 self.view 的 point: ")
        
        // 下面代码打印结果全是: 40.0, 270.0
        printPoint(self.view.convert(cyanView.frame.origin, from: purpleView))
        printPoint(self.view.convert(cyanView.bounds.origin, from: cyanView))
        printPoint(cyanView.convert(cyanView.bounds.origin, to: self.view))
        printPoint(purpleView.convert(cyanView.frame.origin, to: self.view))
        printPoint(self.view.layer.convert(cyanView.layer.frame.origin, from: purpleView.layer))
        printPoint(self.view.layer.convert(cyanView.layer.bounds.origin, from: cyanView.layer))
        printPoint(cyanView.layer.convert(cyanView.layer.bounds.origin, to: self.view.layer))
        printPoint(purpleView.layer.convert(cyanView.layer.frame.origin, to: self.view.layer))
        
        print("2. ------------------------------------------------------")
        
        // 下面代码打印结果全是: 40.0, 270.0, 200.0, 200.0
        print("cyanView 的 frame 相对于 self.view 的 frame: ")
        printFrame(self.view.convert(cyanView.frame, from: purpleView))
        printFrame(self.view.convert(cyanView.bounds, from: cyanView))
        printFrame(cyanView.convert(cyanView.bounds, to: self.view))
        printFrame(purpleView.convert(cyanView.frame, to: self.view))
        printFrame(self.view.layer.convert(cyanView.layer.frame, from: purpleView.layer)) //40.0, 270.0, 200.0, 200.0
        printFrame(self.view.layer.convert(cyanView.layer.bounds, from: cyanView.layer))
        printFrame(cyanView.layer.convert(cyanView.layer.bounds, to: self.view.layer))
        printFrame(purpleView.layer.convert(cyanView.layer.frame, to: self.view.layer))
        
        print("3. ------------------------------------------------------")
        // 下面代码打印结果全是: 80.0, 80.0
        print("yellowView 的 point 相对于 purpleView 的 point: ")
        printPoint(purpleView.convert(yellowView.frame.origin, from: cyanView))
        printPoint(purpleView.convert(yellowView.bounds.origin, from: yellowView))
        printPoint( yellowView.convert(yellowView.bounds.origin, to: purpleView))
        printPoint(cyanView.convert(yellowView.frame.origin, to: purpleView))
        printPoint(purpleView.layer.convert(yellowView.layer.frame.origin, from: cyanView.layer))
        printPoint(purpleView.layer.convert(yellowView.layer.bounds.origin, from: yellowView.layer))
        printPoint(yellowView.layer.convert(yellowView.layer.bounds.origin, to: purpleView.layer))
        printPoint(cyanView.layer.convert(yellowView.layer.frame.origin, to: purpleView.layer))
        
        print("4. ------------------------------------------------------")
        // 下面代码打印结果全是: 80.0, 80.0, 100.0, 100.0
        print("yellowView 的 frame 相对于 purpleView 的 frame: ")
        printFrame(purpleView.convert(yellowView.frame, from: cyanView))
        printFrame(purpleView.convert(yellowView.bounds, from: yellowView))
        printFrame( yellowView.convert(yellowView.bounds, to: purpleView))
        printFrame(cyanView.convert(yellowView.frame, to: purpleView))
        printFrame(purpleView.layer.convert(yellowView.layer.frame, from: cyanView.layer))
        printFrame(purpleView.layer.convert(yellowView.layer.bounds, from: yellowView.layer))
        printFrame(yellowView.layer.convert(yellowView.layer.bounds, to: purpleView.layer))
        printFrame(cyanView.layer.convert(yellowView.layer.frame, to: purpleView.layer))
    }
    
    func printFrame(_ rect: CGRect) {
        print("\(rect.origin.x), \(rect.origin.y), \(rect.size.width), \(rect.size.height)")
    }
    
    func printPoint(_ point: CGPoint) {
        print("\(point.x), \(point.y)")
    }
}
