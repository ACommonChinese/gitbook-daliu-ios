//
//  ExtensionUtils.swift
//  demo
//
//  Created by 刘威振 on 2020/6/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

import UIKit

//let screenWidth: CGFloat = {
//    return UIScreen.main.bounds.size.width
//} ()

func getScreenWidth() -> CGFloat {
    let orientation: UIDeviceOrientation = UIDevice.current.orientation
    switch orientation {
    case .landscapeLeft, .landscapeRight:
        return UIScreen.main.bounds.size.height
    default:
        return UIScreen.main.bounds.size.width
    }
}

let isiPhone: Bool = {
    return UIDevice.current.userInterfaceIdiom == .phone
} ()

let isiPhoneX: Bool = {
    guard isiPhone else {
        return false
    }
    // Must be higher than iOS1.0
    // Call it after set window
    guard let window = UIApplication.shared.delegate?.window else {
        return false
    }
    return window!.safeAreaInsets.bottom > 0
} ()

let navigationBarHeight: CGFloat = {
    return isiPhoneX ? 64.0 : 88.0
} ()

let bottomMargin: CGFloat = {
    return isiPhoneX ? 34.0 : 0
} ()

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

extension UIViewController {
    public func validViewRect() -> CGRect {
        var rect = UIScreen.main.bounds
        if self.navigationController != nil && self.navigationController?.navigationBar != nil && self.navigationController!.navigationBar.isHidden == false {
            rect.size.height -= navigationBarHeight
        }
        if self.tabBarController != nil && self.tabBarController?.tabBar != nil && self.tabBarController!.tabBar.isHidden == false {
            rect.size.height = rect.size.height - bottomMargin - self.tabBarController!.tabBar.frame.height
        }
        return rect
    }
}
