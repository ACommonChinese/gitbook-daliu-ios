//
//  DemoFilterVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class DemoFilterVC: UIViewController {
    let hour1: UIView = UIView()
    let hour2: UIView = UIView()
    let minute1: UIView = UIView()
    let minute2: UIView = UIView()
    let second1: UIView 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        var digitViews = Array<UIView>()
        
    }
    
    func addItemViews() {
        let margin = 20
        let width = screenWidth / 2 / 6
        let height = width * 1.5
        for i in 0..<6 {
            let view = UIView(frame: CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>))
        }
    }
    
    //MARK: - About rotation
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
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
}
