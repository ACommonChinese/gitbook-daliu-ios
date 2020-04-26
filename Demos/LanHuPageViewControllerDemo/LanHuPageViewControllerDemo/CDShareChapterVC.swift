//
//  CDShareChapterVC.swift
//  LanHuPageViewControllerDemo
//
//  Created by liuweizhen on 2020/4/4.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit
import SnapKit

class CDShareChapterVC: UIViewController {

    public static func loadFromStoryboard() -> CDShareChapterVC {
        let storyboard: UIStoryboard = UIStoryboard(name: "CDShareChapterVC", bundle: Bundle.main)
        if #available(iOS 13.0, *) {
            return storyboard.instantiateInitialViewController()!
            // Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
        } else {
            // Fallback on earlier versions
            return storyboard.instantiateViewController(withIdentifier: "CDShareChapterVC") as! CDShareChapterVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIView()
        testView.backgroundColor = UIColor.cyan
        view.addSubview(testView)
        testView.snp.remakeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.left.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.purple
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
