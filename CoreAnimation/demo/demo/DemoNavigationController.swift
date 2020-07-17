//
//  DemoNavigationController.swift
//  demo
//
//  Created by 刘威振 on 2020/7/14.
//  Copyright © 2020 刘威振. All rights reserved.
//  https://blog.csdn.net/ljc_563812704/article/details/81901878
//  https://www.cnblogs.com/lear/p/5051818.html
// https://blog.csdn.net/a123473915/article/details/80224860?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.nonecase

import UIKit

class DemoNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var shouldAutorotate: Bool {
        guard let topVC = self.topViewController else {
            return false
        }
        return topVC.shouldAutorotate
    }
    
    //viewController所支持的全部旋转方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let topVC = self.topViewController else {
            return .all
        }
        return topVC.supportedInterfaceOrientations
    }
}
