//
//  ExtensionUtils.swift
//  demo
//
//  Created by 刘威振 on 2020/6/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect.init(origin: CGPoint(x: x, y: y), size: CGSize.init(width: width, height: height))
}

func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x: x, y: y)
}

func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize.init(width: width, height: height)
}

extension CGSize {
    public static func scaleSize(fixWidth: CGFloat, forSize size: CGSize) -> CGSize {
        let  height = (fixWidth * size.height) / size.width
        return CGSizeMake(fixWidth, height)
    }
    
    public static func scaleSize(fixHeight: CGFloat, forSize size: CGSize) -> CGSize {
        let width = size.width * fixHeight / size.height
        return CGSizeMake(width, fixHeight)
    }
}
