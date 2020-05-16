//
//  MyView.swift
//  横向tableview
//
//  Created by liuweizhen on 2020/5/16.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

class MyView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    static func loadFromXib() -> MyView {
        let myView: MyView = Bundle.main.loadNibNamed("MyView", owner: nil, options: nil)!.first as! Self
        return myView;
    }
    
    override func didMoveToSuperview() {
        // self.tableView.showsVerticalScrollIndicator = false
        self.tableView.register(UINib.init(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        
        self.tableView.frame = self.bounds;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        print("1. before transform: ", self.tableView.frame) // (0.0, 0.0, 375.0, 100.0)
        
        // 先把tableView逆时针旋转90度
        self.tableView.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Float.pi/2)) // -M_PI_2
        
        print("2. after transform: ", self.tableView.frame) // (137.49998584414396, -137.50000377489442, 100.00002831171204, 375.00000754978885)
        
        self.tableView.frame = self.bounds
        print("3. after transform and reset frame: ", self.tableView.frame) // // (-7.549787824245868e-06, -1.4210854715202004e-14, 375.00001509957565, 100.00000000000001)
    }
    
    // MARK: -  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.label.text = String(format: "%ld", indexPath.row)
        cell.backgroundColor = UIColor.purple
        
        // 再把cell顺时针旋转90度
        cell.contentView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi/2))
        cell.contentView.backgroundColor = UIColor.green
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height -> cell的width
        return 60;
    }
}
