//
//  DemoTheoryVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/30.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoTheoryVC: UIViewController {
    private let layerView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        /**
         https://developer.apple.com/documentation/coregraphics/cgaffinetransform
         x` = ax + cy + t_x
         y` = bx + dy + t_y
         
         因此 `CGAffineTransform.identity` 就是只有a和d为1, 其他均为0
         */
        let transform: CGAffineTransform = CGAffineTransform.identity
        print("CGAffineTransform.identity的参数值: ")
        print(transform.a)  // 1.0
        print(transform.b)  // 0.0
        print(transform.c)  // 0.0
        print(transform.d)  // 1.0
        print(transform.tx) // 0.0
        print(transform.ty) // 0.0
        
        self.createUI()
    }
    
    func createUI() {
        let image: UIImage = UIImage(named: "Snowman")!
        
        layerView.frame = CGRect.init(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height)
        layerView.backgroundColor = UIColor.white
        layerView.center = self.view.center
        layerView.layer.contentsGravity = CALayerContentsGravity.resizeAspect
        layerView.layer.contents = image.cgImage
        self.view.addSubview(layerView)
        
        let label: UILabel = UILabel.init(frame: CGRectMake(0, layerView.frame.maxY + 50, getScreenWidth(), 30))
        label.textAlignment = .center
        label.text = "点击缩小为原来的2分之1, 然后向右向上移动100"
        self.view.addSubview(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var transform = CGAffineTransform.identity
        transform.d = 0.5
        transform.a = 0.5
     
        UIView.animate(withDuration: 1.25, animations: {
            self.layerView.layer.setAffineTransform(transform)
        }) { (f) in
            UIView.animate(withDuration: 1.25) {
                transform.tx = 100.0
                transform.ty = -100.0
                self.layerView.layer.setAffineTransform(transform)
            }
        }
    }
}
