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
    
    public static func all() -> [TransformType] {
        return [
            .SimpleRotation
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
        
        /**
        - 旋转: CGAffineTransformMakeRotation(CGFloat angle)
        - 缩放: CGAffineTransformMakeScale(CGFloat sx, CGFloat sy)
        - 平移: CGAffineTransformMakeTranslation(CGFloat tx, CGFloat ty)
         
         `UIView`可以通过设置`transform(CGAffineTransform)`属性做变换，但实际上它只是封装了内部图层的变换
         `CALayer`同样也有一个`transform`属性，但它的类型是`CATransform3D`，而不是`CGAffineTransform`
         `CALayer`对应于`UIView`的`transform`属性叫做`affineTransform`
         下面示例子使用`affineTransform`对图层做了45度顺时针旋转
         */
        
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
}
