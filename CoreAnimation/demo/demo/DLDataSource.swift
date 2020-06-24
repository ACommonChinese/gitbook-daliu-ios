//
//  DLDataSource.swift
//  demo
//
//  Created by 刘威振 on 2020/6/3.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

enum DLTitle: String {
    /// 图层与视图
    case Layer = "图层与视图"
    /// 寄宿图
    case Contents = "寄宿图"
    /// CustomDrawing
    case CustomDrawing = "CustomDrawing"
    case Anchor = "锚点"
    case Coordinate = "坐标系和坐标转换"
    case HitTesting = "HitTesting"
    case CornerRadius = "圆角"
    case Border = "边框"
    case Shadow = "阴影"
    case Mask = "mask蒙板"
    case Filter = "Filter拉伸过滤"
    case Alpha = "Alpha"
    case AffineTransform = "CGAffineTransform仿射变换"
    case Transform3D = "CATransform3D变换"
    case Solid = "固体对象"
    case ShapeLayer = "CAShapeLayer"
    
    public static func all() -> [DLTitle] {
        return [.Layer, .Contents, .Anchor, .Coordinate]
    }
}

class DLDataSource: NSObject {
    
}
