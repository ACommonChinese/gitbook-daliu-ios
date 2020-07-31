//
//  Demo3DVC.swift
//  demo
//
//  Created by 刘威振 on 2020/7/31.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

enum ThreeD: String {
    case Theory = "原理"
    case Common = "旋转 缩放 平移"
    
    public static func all() -> [ThreeD] {
        return [
            .Theory,
            .Common
        ]
    }
}

class Demo3DVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = UIColor.gray
        self.tableView.frame = validViewRect()
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThreeD.all().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let type = ThreeD.all()[indexPath.row]
        cell.textLabel?.text = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type: ThreeD = ThreeD.all()[indexPath.row]
        switch type {
            case .Theory:
                self.navigationController?.pushViewController(Demo3DTheoryVC(), animated: true)
            case .Common:
                self.navigationController?.pushViewController(Demo3DCommonVC(), animated: true)
        }
    }
}
