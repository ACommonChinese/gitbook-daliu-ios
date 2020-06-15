//
//  ViewController.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView! = UITableView(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: UIScreen.main.bounds.size.width, height: 200)), style: UITableView.Style.plain)
    var items: [DLTitle] = DLTitle.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Core Animation"
        self.view.backgroundColor = UIColor.white

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let dlTitle: DLTitle = self.items[indexPath.row]
        cell.textLabel?.text = dlTitle.rawValue
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title: String = self.items[indexPath.row].rawValue
        switch title {
        case DLTitle.Layer.rawValue: /// 图层与视图
            self.navigationController?.pushViewController(DemoLayerVC(), animated: true)
        case DLTitle.Contents.rawValue: /// 寄宿图
            self.navigationController?.pushViewController(DemoContentsVC(), animated: true)
        default:
            print("Not found")
        }
    }
}

