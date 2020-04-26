//
//  CDShareNoteVC.swift
//  LanHuPageViewControllerDemo
//
//  Created by liuweizhen on 2020/4/4.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

class CDShareNoteVC: UIViewController {
    public static func loadFromStoryboard() -> CDShareNoteVC {
        // NSStringFromClass(CDShareNoteVC.self: LanHuPageViewControllerDemo.CDShareNoteVC
        let storyboard: UIStoryboard = UIStoryboard(name: "CDShareNoteVC", bundle: Bundle.main)
        if #available(iOS 13.0, *) {
            return storyboard.instantiateInitialViewController()!
        } else {
            // Fallback on earlier versions
            return storyboard.instantiateViewController(withIdentifier: "CDShareNoteVC") as! CDShareNoteVC
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        self.view.backgroundColor = UIColor.green
    }

}
