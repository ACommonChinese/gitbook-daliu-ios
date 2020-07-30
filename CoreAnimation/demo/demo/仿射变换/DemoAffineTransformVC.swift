//
//  DemoAffineTransformVC.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

enum TransformType: String {
    case SimpleRotation = "旋转45度"
    case MixTransform = "混合变换"
    case Theory = "原理"
    case ShearTransform = ".shear斜切变换"
    
    public static func all() -> [TransformType] {
        return [
            .SimpleRotation,
            .MixTransform,
            .Theory,
            .ShearTransform
        ];
    }
}

class DemoAffineTransformVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return TransformType.all().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let type = TransformType.all()[indexPath.row]
        cell.textLabel?.text = type.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type: TransformType = TransformType.all()[indexPath.row]
        switch type {
        case .SimpleRotation:
            self.navigationController?.pushViewController(DemoSimpleRotationVC(), animated: true)
        case .MixTransform:
            self.navigationController?.pushViewController(DemoMixTransformVC(), animated: true)
        case .Theory:
            self.navigationController?.pushViewController(DemoTheoryVC(), animated: true)
        case .ShearTransform:
            self.navigationController?.pushViewController(DemoShearTransformVC(), animated: true)
        }
    }
}
