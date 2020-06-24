//
//  MyConstraintView.swift
//  横向tableview
//
//  Created by liuweizhen on 2020/5/16.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

class MyConstraintView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    static func loadFromXib() -> MyConstraintView {
        let myView: MyConstraintView = Bundle.main.loadNibNamed("MyConstraintView", owner: nil, options: nil)!.first as! Self
        return myView;
    }
    
    override func didMoveToSuperview() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1.0).isActive = true
        self.tableView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.0).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.tableView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.tableView.backgroundColor = UIColor.red
        self.tableView.register(UINib.init(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        
        // self.tableView.frame = self.bounds;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        // 先把tableView逆时针旋转90度
        self.tableView.transform = CGAffineTransform.init(rotationAngle: CGFloat(-Float.pi/2)) // -M_PI_2
    }
        
    // MARK: -  UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyCell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.label.text = String(format: "%ld", indexPath.row)
        cell.backgroundColor = UIColor.clear
        
        let redView = UIView(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 320, height: 40)))
        //redView.backgroundColor = UIColor.cyan
        //cell.selectedBackgroundView = redView
        let layer = JKWWMainUtils.verticalHighlightLayerWithFrame(frame: redView.bounds)
        redView.layer.addSublayer(layer)
        cell.selectedBackgroundView = redView
        
        // 再把cell顺时针旋转90度
        cell.contentView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi/2))
        //cell.contentView.backgroundColor = UIColor.yellow
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height -> cell的width
        return 60;
    }
}
