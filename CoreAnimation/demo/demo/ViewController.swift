//
//  ViewController.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

enum DLTitle: String {
    case Layer = ".Layer 图层与视图"
    case Contents = ".Contents 寄宿图"
    case CustomDrawing = "CustomDrawing"
    case Anchor = ".Anchor 锚点"
    case Coordinate = ".Coordinate 坐标系和坐标转换"
    case HitTesting = "HitTesting"
    case ZPosition = "ZPosition"
    case HitTestingAndZPosition = ".HitTestingAndZPosition ZPosition引发的HitTesting问题"
    case LayoutSublayersOfLayer = "LayoutSublayersOfLayer"
    case CornerRadius = ".CornerRadius 圆角和边框"
    case Shadow = ".Shadow 阴影"
    case Mask = ".Mask 图层蒙板"
    case Filter = ".Filter 伸缩过滤"
    case Rasterization = ".Rasterization 组透明"
    case AffineTransform = ".CGAffineTransform仿射变换"
    case Transform3D = "CATransform3D变换"
    case Solid = "固体对象"
    case ShapeLayer = "CAShapeLayer"
    
    public static func all() -> [DLTitle] {
        return [.Layer,
                .Contents,
                .Anchor,
                .Coordinate,
                .ZPosition,
                .HitTesting,
                .HitTestingAndZPosition,
                .LayoutSublayersOfLayer,
                .CornerRadius,
                .Shadow,
                .Mask,
                .Filter,
                .Rasterization,
                .AffineTransform]
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView! = UITableView(frame: CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)), style: UITableView.Style.plain)
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
        let title: DLTitle = self.items[indexPath.row]
        switch title {
        case .Layer: //图层与视图
            self.navigationController?.pushViewController(DemoLayerVC(), animated: true)
        case .Contents: //寄宿图
            self.navigationController?.pushViewController(DemoContentsVC(), animated: true)
        case .Anchor: //锚点
            self.navigationController?.pushViewController(DemoAnchorVC(), animated: true)
        case .Coordinate: //坐标系和坐标转换
            self.navigationController?.pushViewController(DemoCoordinateVC(), animated: true)
        case .ZPosition: //ZPosition改变图层显示顺序
            self.navigationController?.pushViewController(DemoZPositionVC(), animated: true)
        case .HitTesting: //CALayer的响应者链相关的东西
            self.navigationController?.pushViewController(DemoHitTestingVC(), animated: true)
        case .HitTestingAndZPosition: //ZPosition引发的HitTesting问题
            self.navigationController?.pushViewController(DemoHitTestingAndZPositionVC(), animated: true)
        case .LayoutSublayersOfLayer:
            self.navigationController?.pushViewController(DemoLayoutSublayersOfLayerVC(), animated: true)
        case .CornerRadius:
            self.navigationController?.pushViewController(DemoCornerRadiusVC(), animated: true)
        case .Shadow:
            self.navigationController?.pushViewController(DemoShadowVC(), animated: true)
        case .Mask:
            self.navigationController?.pushViewController(DemoMaskVC(), animated: true)
        case .Filter:
            let vc = DemoFilterVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .Rasterization:
            self.navigationController?.pushViewController(DemoRasterizationVC(), animated: true)
        case .AffineTransform:
            self.navigationController?.pushViewController(DemoAffineTransformVC(), animated: true)
        default:
            print("Not found")
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
}
