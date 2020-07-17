//
//  DemoMaskVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoMaskVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.isTranslucent = false
        let demoImg = UIImage.init(named: "4.12.png")
        let screenWidth = UIScreen.main.bounds.size.width
        let size = CGSize.scaleSize(fixWidth: screenWidth, forSize: demoImg!.size)
        let imgView = UIImageView.init(frame: CGRectMake(0, 0, size.width, size.height))
        imgView.image = demoImg
        self.view.addSubview(imgView)
        
        /**
         CALayer有一个属性叫做`mask`, 这个属性本身就是个CALayer类型，有和其他图层一样的绘制和布局属性
         它类似于一个子图层，相对于父图层（即拥有该属性的图层）布局，但是它却不是一个普通的子图层。
         不同于那些绘制在父图层中的子图层，`mask`图层定义了父图层的部分可见区域
         `mask`图层的`Color`属性是无关紧要的，真正重要的是图层的轮廓。`mask`属性就像是一个饼干切割机，`mask`图层实心的部分会被保留下来，其他的则会被抛弃
         如果`mask`图层比父图层要小，只有在`mask`图层里面的内容才是它关心的，除此以外的一切都会被隐藏起来
         */
        let length: CGFloat = 256.0
        let targetImgView: UIImageView = UIImageView(frame: CGRectMake((screenWidth-length)/2.0, imgView.frame.maxY+10, length, length))
        targetImgView.image = UIImage.init(named: "Igloo")
        self.view.addSubview(targetImgView)
        
        //create mask layer
        let maskLayer: CALayer = CALayer()
        maskLayer.frame = targetImgView.bounds
        let maskImage: UIImage = UIImage.init(named: "Cone")!
        maskLayer.contents = maskImage.cgImage
        
        //apply mask to image layer￼
        targetImgView.layer.mask = maskLayer
        // 注: CALayer蒙板图层真正厉害的地方在于蒙板图不局限于静态图。任何有图层构成的都可以作为`mask`属性，这意味着你的蒙板可以通过代码甚至是动画实时生成
    }
}
