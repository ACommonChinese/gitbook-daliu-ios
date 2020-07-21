//
//  DemoFilterVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoFilterVC: UIViewController {
    let hour: UIView    = UIView()
    let minute: UIView  = UIView()
    let second: UIView  = UIView()
    let hour1: UIView   = UIView()
    let hour2: UIView   = UIView()
    let minute1: UIView = UIView()
    let minute2: UIView = UIView()
    let second1: UIView = UIView()
    let second2: UIView = UIView()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        self.view.addSubview(hour)
        self.view.addSubview(minute)
        self.view.addSubview(second)
        hour.addSubview(hour1)
        hour.addSubview(hour2)
        minute.addSubview(minute1)
        minute.addSubview(minute2)
        second.addSubview(second1)
        second.addSubview(second2)
        self.hour.backgroundColor = UIColor.white
        self.minute.backgroundColor = UIColor.white
        self.second.backgroundColor = UIColor.white
        
        let digits = UIImage(named: "Digits.png")
        for view in [hour1, hour2, minute1, minute2, second1, second2] {
            view.layer.contents = digits?.cgImage
            view.layer.contentsRect = CGRect.init(x: 0, y: 0, width: 0.1, height: 1.0)
            view.layer.contentsGravity = CALayerContentsGravity.resizeAspect
            
            /**
             最后我们再来谈谈`minificationFilter`和`magnificationFilter`属性。总得来讲，当我们视图显示一个图片的时候，都应该正确地显示这个图片（意即：以正确的比例和正确的1：1像素显示在屏幕上）。原因如下：

             * 能够显示最好的画质，像素既没有被压缩也没有被拉伸。
             * 能更好的使用内存，因为这就是所有你要存储的东西。
             * 最好的性能表现，CPU不需要为此额外的计算。

             不过有时候，显示一个非真实大小的图片确实是我们需要的效果。比如说一个头像或是图片的缩略图，再比如说一个可以被拖拽和伸缩的大图。这些情况下，为同一图片的不同大小存储不同的图片显得又不切实际。

             当图片需要显示不同的大小的时候，有一种叫做*拉伸过滤*的算法就起到作用了。它作用于原图的像素上并根据需要生成新的像素显示在屏幕上。

             事实上，重绘图片大小也没有一个统一的通用算法。这取决于需要拉伸的内容，放大或是缩小的需求等这些因素。`CALayer`为此提供了三种拉伸过滤方法，他们是：

             * kCAFilterLinear
             * kCAFilterNearest
             * kCAFilterTrilinear

             minification（缩小图片）和magnification（放大图片）默认的过滤器都是`kCAFilterLinear`，这个过滤器采用双线性滤波算法，它在大多数情况下都表现良好。双线性滤波算法通过对多个像素取样最终生成新的值，得到一个平滑的表现不错的拉伸。但是当放大倍数比较大的时候图片就模糊不清了。

             `kCAFilterTrilinear`和`kCAFilterLinear`非常相似，大部分情况下二者都看不出来有什么差别。但是，较双线性滤波算法而言，三线性滤波算法存储了多个大小情况下的图片（也叫多重贴图），并三维取样，同时结合大图和小图的存储进而得到最后的结果
             
             总的来说，对于比较小的图或者是差异特别明显，极少斜线的大图，最近过滤算法会保留这种差异明显的特质以呈现更好的结果。但是对于大多数的图尤其是有很多斜线或是曲线轮廓的图片来说，最近过滤算法会导致更差的结果。换句话说，线性过滤保留了形状，最近过滤则保留了像素的差异
             */
            view.layer.magnificationFilter = CALayerContentsFilter.nearest
        }
        
        refreshLayout()
        
        //start timer
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        //set initial clock time
        tick()
    }
    
    @objc func tick() {
        let calendar: NSCalendar = NSCalendar(identifier: .gregorian)!
        let units: NSCalendar.Unit = [.hour, .minute, .second];
        let components: DateComponents = calendar.components(units, from: Date())
        let hour1   = components.hour! / 10
        let hour2   = components.hour! % 10
        let minute1 = components.minute! / 10
        let minute2 = components.minute! % 10
        let second1 = components.second! / 10
        let second2 = components.second! % 10
        setDigit(digit: hour1, forView: self.hour1)
        setDigit(digit: hour2, forView: self.hour2)
        setDigit(digit: minute1, forView: self.minute1)
        setDigit(digit: minute2, forView: self.minute2)
        setDigit(digit: second1, forView: self.second1)
        setDigit(digit: second2, forView: self.second2)
    }
    
    func setDigit(digit: Int, forView: UIView) {
        forView.layer.contentsRect = CGRect.init(x: Double(digit)*0.1, y: 0.0, width: 0.1, height: 1.0)
    }
    
    func refreshLayout() {
        refreshLayout(UIScreen.main.bounds.size)
    }
    
    func refreshLayout(_ size: CGSize) {
        let margin         = 50.0
        let padding        = 20.0
        let width: Double  = (Double(size.width) - 2*margin - 2*padding) / 3
        self.hour.frame    = CGRect.init(x: margin, y: margin, width: width, height: 200)
        self.minute.frame  = CGRect.init(x: Double(self.hour.frame.maxX) + padding, y: margin, width: width, height: 200)
        self.second.frame  = CGRect.init(x: Double(self.minute.frame.maxX) + padding, y: margin, width: width, height: 200)
        self.hour1.frame   = CGRect.init(x: 0, y: 0, width: self.hour.frame.width/2.0, height: self.hour.frame.height)
        self.hour2.frame   = CGRect.init(x: self.hour.frame.width/2.0, y: 0, width: self.hour.frame.width/2.0, height: self.hour.frame.height)
        self.minute1.frame = CGRect.init(x: 0, y: 0, width: self.minute.frame.width/2.0, height: self.minute.frame.height)
        self.minute2.frame = CGRect.init(x: self.minute.frame.width/2.0, y: 0, width: self.minute.frame.width/2.0, height: self.minute.frame.height)
        self.second1.frame = CGRect.init(x: 0, y: 0, width: self.second.frame.width/2, height: self.second.frame.height)
        self.second2.frame = CGRect.init(x: self.second.frame.width/2.0, y: 0, width: self.second.frame.width/2.0, height: self.second.frame.height)
    }
    
    //MARK: - About rotation
    
    override func viewDidLayoutSubviews() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            print("横屏 \(UIScreen.main.bounds.width)")
        default:
            print("竖屏 \(UIScreen.main.bounds.width)")
        }
        refreshLayout()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight, .portrait]
    }
    
    /**
    override func viewWillAppear(_ animated: Bool) {
        //UIDevice.current.orientation = // readonly
        //UIDevice.current.orientation
        UIDevice.current.setValue(NSNumber.init(value: UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
    }
    */
    
    //用于presentViewController full screen的场景
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //refreshLayout(size) // 转屏后的宽高
    }
}
