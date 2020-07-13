//
//  DemoShadowVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoShadowVC: UIViewController {
    let screenWidth = UIScreen.main.bounds.width
    let scrollView = UIScrollView(frame: .zero)
    let layerView1 = UIView(frame: CGRectMake((UIScreen.main.bounds.width - 200)/2.0, 35, 200, 200))
    let layerView2 = UIView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        scrollView.backgroundColor = UIColor.gray
        scrollView.frame = self.validViewRect()
        self.view.addSubview(scrollView)
        layerView1.backgroundColor = UIColor.white
        addLabel("普通阴影", originY: 10)
                /**
         阴影往往可以达到图层深度暗示的效果
         给`shadowOpacity`属性一个大于默认值（也就是0）的值，阴影就可以显示在任意图层之下
         `shadowOpacity`是一个必须在0.0（不可见）和1.0（完全不透明）之间的浮点数。如果设置为1.0，将会显示一个有轻微模糊的黑色阴影稍微在图层之上。若要改动阴影的表现，你可以使用CALayer的另外三个属性：
         shadowColor: 控制着阴影的颜色, 类型也是`CGColorRef`, 默认黑色
         shadowOffset: 控制着阴影的方向和距离, 它是一个`CGSize`的值，宽度控制着阴影横向的位移，高度控制着纵向的位移。`shadowOffset`的默认值是 {0, -3}，意即阴影相对于Y轴有3个点的向上位移
         为什么要默认向上的阴影呢？尽管Core Animation是从Layer Kit演变而来（可以认为是为iOS创建的私有动画框架），但是呢，它却是在Mac OS上面世的，前面有提到，二者的Y轴是颠倒的。这就导致了默认的3个点位移的阴影是向上的。在Mac上，`shadowOffset`的默认值是阴影向下的，这样你就能理解为什么iOS上的阴影方向是向上的了
         shadowRadius:`shadowRadius`属性控制着阴影的*模糊度*，当它的值是0的时候，阴影就和视图一样有一个非常确定的边界线。当值越来越大的时候，边界线看上去就会越来越模糊和自然。苹果自家的应用设计更偏向于自然的阴影，所以一个非零值再合适不过了
         */
        scrollView.addSubview(layerView1)
        // ----------------------------------------------
        // 普通阴影设置方法
        // ----------------------------------------------
        addShadow(layerView1)
        /**
         layerView1.layer.masksToBounds = true  // 这相当于:layerView1.clipsToBounds = true
         会导致阴影失效
         */
        
        // ----------------------------------------------
        // 阴景和寄宿图
        // ----------------------------------------------
        //和图层边框不同，图层的阴影来源于其内容的确切形状，而不是仅仅是边界和`cornerRadius`
        //阴影是根据寄宿图的轮廓来确定的
        var label = addLabel("阴影和寄宿图", originY: layerView1.frame.maxY + 20)
        var frame = layerView1.frame
        frame.origin.y = label.frame.maxY + 10
        layerView2.frame = frame
        let image: UIImage = UIImage(named: "Snowman.png")!
        layerView2.layer.contents = image.cgImage
        layerView2.contentScaleFactor = image.scale
        layerView2.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        scrollView.addSubview(layerView2)
        addShadow(layerView2)
        
        // ----------------------------------------------
        // 当阴影和裁剪扯上关系的时候就有一个头疼的限制：阴影通常就是在Layer的边界之外，
        // 如果你开启了`masksToBounds`属性，所有从图层中突出来的内容都会被才剪掉
        // 如下示例, `maskToBounds`属性裁剪掉了阴影和内容
        // ----------------------------------------------
        label = addLabel("裁剪和阴影结合的问题", originY: layerView2.frame.maxY + 10)
        let layerView3: UIView     = UIView(frame: CGRectMake(40, label.frame.maxY + 50, screenWidth - 80, 200))
        let layerView3Sub: UIView  = UIView(frame: CGRectMake(-30, -30, 100, 100))
        let layerView4: UIView     = UIView(frame: CGRectMake(40, layerView3.frame.maxY + 40, screenWidth - 80, 200))
        let layerView4Sub: UIView  = UIView(frame: CGRectMake(-30, -30, 100, 100))
        layerView3.backgroundColor = UIColor.white
        layerView4.backgroundColor = UIColor.white
        layerView3Sub.backgroundColor = UIColor.red
        layerView4Sub.backgroundColor = UIColor.red
        layerView3.layer.cornerRadius = 20
        layerView3.layer.borderWidth  = 5
        layerView4.layer.cornerRadius = 20
        layerView4.layer.borderWidth  = 5
        addShadow(layerView3)
        addShadow(layerView4)
        scrollView.addSubview(layerView3)
        scrollView.addSubview(layerView4)
        layerView3.addSubview(layerView3Sub)
        layerView4.addSubview(layerView4Sub)
        layerView4.layer.masksToBounds = true
        
        // ----------------------------------------------
        // 从技术角度来说，`maskToBounds`属性裁剪掉了阴影和内容这个结果是可以的, 但确实又不是我们想要的效果.
        // 如果既想裁切内容又想有阴影效果，你就需要用到两个图层：一个只画阴影的空的外图层，和一个用`masksToBounds`裁剪内容的内图层
        // ----------------------------------------------
        label = addLabel("解决`maskToBounds`属性裁剪掉了阴影的问题", originY: layerView4.frame.maxY + 20)
        let layerView5: UIView = UIView(frame: CGRectMake(40, label.frame.maxY + 20, screenWidth - 80, 200))
        let shadowLayerView = UIView(frame: layerView5.frame)
        shadowLayerView.backgroundColor = UIColor.white
        shadowLayerView.layer.cornerRadius = 20
        shadowLayerView.layer.borderWidth = 5.0
        addShadow(shadowLayerView)
        scrollView.addSubview(shadowLayerView)
        
        layerView5.backgroundColor = UIColor.white
        layerView5.layer.cornerRadius = 20
        layerView5.layer.borderWidth = 5
        layerView5.layer.masksToBounds = true
        let layerView5Sub: UIView  = UIView(frame: CGRectMake(-30, -30, 100, 100))
        layerView5Sub.backgroundColor = UIColor.red
        layerView5.addSubview(layerView5Sub)
        scrollView.addSubview(layerView5)
        
        // ----------------------------------------------
        // shadowPath属性
        // 图层阴影并不总是方的，而是从图层内容的形状衍生而来。这看上去不错，但是实时计算阴影也是非常消耗资源的，尤其是当图层有多个子图层，每个图层还有一个有透明效果的寄宿图的时候。
        // 如果你事先知道你的阴影形状会是什么样子的，你可以通过指定一个`shadowPath`来提高性能。`shadowPath`是一个`CGPathRef`类型（一个指向`CGPath`的指针）。
        // GPath`是一个Core Graphics对象，用来指定任意的一个矢量图形。我们可以通过这个属性独立于图层形状之外指定阴影的形状。
        // 下面示例展示了同一寄宿图的不同阴影设定。如你所见，我们使用的图形很简单，但是它的阴影可以是你想要的任何形状
        // ----------------------------------------------
        let content = UIImage(named: "Cone")
        let size = content!.size
        let layerView6 = UIView(frame: CGRectMake((screenWidth-size.width)/2, layerView5.frame.maxY + 20, size.width, size.height))
        layerView6.layer.contents = content?.cgImage
        layerView6.layer.contentsScale = content!.scale
        scrollView.addSubview(layerView6)
        frame = layerView6.frame
        frame.origin.y = layerView6.frame.maxY + 30
        let layerView7 = UIView(frame: frame)
        layerView7.layer.contents = content?.cgImage
        layerView7.layer.contentsScale = content!.scale
        scrollView.addSubview(layerView7)
        //enable layer shadows
        layerView6.layer.shadowOpacity = 0.5
        layerView7.layer.shadowOpacity = 0.5
        //create a square shadow
        //addShadow(layerView6)
        let squarePath: CGMutablePath = CGMutablePath()
        squarePath.addRect(layerView6.bounds)
        layerView6.layer.shadowPath = squarePath
        //create a circular shadow
        let circlePath: CGMutablePath = CGMutablePath()
        circlePath.addEllipse(in: layerView7.bounds)
        layerView7.layer.shadowPath = circlePath
        // 注:如果是一个矩形或者是圆，用`CGPath`会相当简单明了。
        // 但是如果是更加复杂一点的图形，`UIBezierPath`类会更合适，它是一个由UIKit提供的在CGPath基础上的包装类
        
        resetScrollContentSize(maxY: (layerView7).frame.maxY)
    }
    
    func addShadow(_ v: UIView) {
        v.layer.shadowOpacity = 1
        v.layer.shadowOffset = CGSize.init(width: 0, height: 10)
        v.layer.shadowRadius = 5
    }
    
    @discardableResult
    func addLabel(_ str: String, originY: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRectMake(0, originY, UIScreen.main.bounds.width, 20))
        label.textAlignment = .center
        label.text = str
        label.adjustsFontSizeToFitWidth = true
        scrollView.addSubview(label)
        return label
    }
    
    func resetScrollContentSize(maxY: CGFloat) {
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, maxY + 10)
    }
}
