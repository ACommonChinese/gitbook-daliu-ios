//
//  ViewController.swift
//  横向tableview
//
//  Created by liuweizhen on 2020/5/16.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

/**
 横向滚动TableView:
     tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
     cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
 
 网上开源方案也有, 比如:
        EasyTableView, https://github.com/alekseyn/EasyTableView
 
 */

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        addView2()
    }
    
    // 基于frame的横向滚动tableViews
    func addView() {
        let myView: MyView = MyView.loadFromXib()
        myView.frame = CGRect.init(x: 0, y: 60, width: UIScreen.main.bounds.size.width, height: 100)
        self.view.addSubview(myView)
        myView.backgroundColor = UIColor.green
    }
    
    // 基于AutoLayout的横向滚动tableViews
    func addView2() {
        let myView: MyConstraintView = MyConstraintView.loadFromXib()
        self.view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        myView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        myView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 230).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        myView.backgroundColor = UIColor.purple
    }
}

