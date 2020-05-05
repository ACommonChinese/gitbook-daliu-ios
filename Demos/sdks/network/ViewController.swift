//
//  ViewController.swift
//  network
//
//  Created by liuweizhen on 2020/5/5.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var items: [DLNetworkEnum] = DLNetworkEnum.all

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.title = "Network"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: UITableViewDelegate, UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let item: DLNetworkEnum = self.items[indexPath.row]
        cell.textLabel?.text = item.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: DLNetworkEnum = self.items[indexPath.row]
        switch item {
        case .Thread:
            print("TODO://")
        case .Operation:
            print("TODO://")
        case .Semaphore:
            print("TODO://")
        case .DispathGroup:
            let vc: DispatchGroupVC = DispatchGroupVC.loadFromStoryboard()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
