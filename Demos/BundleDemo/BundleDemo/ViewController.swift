//
//  ViewController.swift
//  BundleDemo
//
//  Created by liuxing8807@126.com on 2019/8/26.
//  Copyright © 2019 daliu. All rights reserved.
//

import UIKit
import Account

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let items: Array<String> = ["mainBundle", "framework"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.title = "Bundle资源获取"
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controller: MainBundleViewController = MainBundleViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        case 1:
            let controller: LoginViewController = LoginViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            break
        default:
            break
        }
    }
}
