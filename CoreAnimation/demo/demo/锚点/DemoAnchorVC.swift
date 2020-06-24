//
//  DemoAnchorVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

/**
 * 锚点
 */
class DemoAnchorVC: UIViewController {
    let hourHand: UIImageView = UIImageView(frame: CGRectMake(113, 81, 30, 94))
    let minuteHand: UIImageView = UIImageView(frame: CGRectMake(118, 75, 20, 106))
    let secondHand: UIImageView = UIImageView(frame: CGRectMake(124, 77, 8, 102))
    weak var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Anchor 锚点"
        self.view.backgroundColor = UIColor.gray
        clockDemo()
    }
    
    /*
     UIView        CALayer
     frame   <-->   frame      相对于父图层的位置和尺寸
     bounds  <-->   bounds     相对于自己的位置和尺寸（内部坐标，左上角默认0，0）
     center  <-->   position   相对于父图层`anchorPoint`所在的位置
     
     改变视图的`frame`，实际上是在改变位于视图下方`CALayer`的`frame`，不能够独立于图层之外改变视图的`frame`
     对于view或者layer来说，`frame`并不是一个非常清晰的属性，它其实是一个虚拟属性，是根据`bounds`，`position`和`transform`计算而来，所以当其中任何一个值发生改变，frame都会变化。相反，改变frame的值同样会影响到他们当中的值
     frame <--> bounds position transform + (anchor point)
     
     当对图层做变换的时候，比如旋转或者缩放，`frame`实际上代表了覆盖在图层旋转之后的整个轴对齐的矩形区域，也就是说`frame`的宽高可能和`bounds`的宽高不再一致
     
     锚点
     视图的`center`属性和图层的`position`属性都指定了`anchorPoint`相对于父图层的位置。图层的`anchorPoint`通过`position`来控制它的`frame`的位置，你可以认为`anchorPoint`是用来移动图层的把柄
     anchorPoint使用单位坐标，默认`anchorPoint`位于图层的中点(0.5, 0.5), 可以通过指定x和y值小于0或者大于1，使它放置在图层范围之外
     
     `anchorPoint`位于图层的中点(0.5, 0.5), 所以图层的将会以这个点为中心放置。`anchorPoint`属性并没有被`UIView`接口暴露出来，这也是视图的position属性被叫做“center”的原因。但是图层的`anchorPoint`可以被移动，比如你可以把它置于图层`frame`的左上角(anchorPoint设为0,0)，这个时候由于postion没有变化，因此图层的内容将会向右下角的`position`方向移动（图3.3），而不是居中了
     这一点可以这样理解：假如原来的postion为{50, 50}, anchorPoint为{0.5, 0.5}，这时候改变了anchorPoint为{0, 0}, 即锚点跑到了左上角，而position是anchorPoint相对于父视图的位置，由于postion没有变化，那么frame就往右下角移动，以满足position仍然是{50, 50}
     
     改变anchorPoint的场景：比如创建一个模拟闹钟的项目
     */
    
    //Auto-resizing会影响到视图的`frame`，因此如果使用xib，禁掉它
    
    func clockDemo() {
        let bgView: UIView = UIView(frame: CGRectMake(0, 0, 256, 256))
        bgView.backgroundColor = self.view.backgroundColor
        bgView.center = self.view.center
        bgView.backgroundColor = UIColor.red
        self.view.addSubview(bgView)
        
        let clockFace = UIImageView(frame: bgView.bounds)
        clockFace.image = UIImage(named: "ClockFace")
        bgView.addSubview(clockFace)
        
        self.hourHand.image = UIImage(named: "HourHand")
        self.minuteHand.image = UIImage(named: "MinuteHand")
        self.secondHand.image = UIImage(named: "SecondHand")
        
        bgView.addSubview(self.hourHand)
        bgView.addSubview(self.minuteHand)
        bgView.addSubview(self.secondHand)
        
        //start timer
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(tick),
                                          userInfo: nil, repeats: true)
        
        self.hourHand.layer.anchorPoint = CGPointMake(0.5, 0.9)
        self.minuteHand.layer.anchorPoint = CGPointMake(0.5, 0.9)
        self.secondHand.layer.anchorPoint = CGPointMake(0.5, 0.9)
        
        //set initial hand positions
        tick()
    }
    
    @objc
    func tick() {
        //convert time to hours, minutes and seconds
        let calendar: NSCalendar = NSCalendar(identifier: .gregorian)!
        
        let units: NSCalendar.Unit = [.hour, .minute, .second];
        let components: DateComponents = calendar.components(units, from: Date())
        //calculate hour hand angle
        let hourAngle: Double = (Double(components.hour!) / 12.0) * Double.pi * 2.0;
    
        //calculate minute hand angle
        let minuteAngle: Double = (Double(components.minute!) / 60.0) * Double.pi * 2.0;

        //calculate second hand angle
        let secondAngle: Double = (Double(components.second!) / 60.0) * Double.pi * 2.0;
        
        self.hourHand.transform = CGAffineTransform.init(rotationAngle: CGFloat(hourAngle))
        self.minuteHand.transform = CGAffineTransform.init(rotationAngle: CGFloat(minuteAngle))
        self.secondHand.transform = CGAffineTransform.init(rotationAngle: CGFloat(secondAngle))
    }
}
