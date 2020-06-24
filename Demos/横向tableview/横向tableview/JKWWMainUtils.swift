//
//  JKWWMainUtils.swift
//  横向tableview
//
//  Created by 刘威振 on 2020/6/23.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import Foundation
import UIKit

class JKWWMainUtils {
    public static func verticalHighlightLayerWithFrame(frame: CGRect) -> CAGradientLayer {
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x:0.5, y:1)
        layer.colors = [UIColor(white: 1.0, alpha: 0.0).cgColor, UIColor(white: 1.0, alpha: 0.16).cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
        layer.locations = [0, 0.5, 1.0]
        return layer
    }
}

//+ (CAGradientLayer *)verticalHighlightLayerWithFrame:(CGRect)frame {
//    CAGradientLayer *layer = [CAGradientLayer layer];
//    layer.frame = frame;
//    layer.startPoint = CGPointMake(0.5, 0);
//    layer.endPoint = CGPointMake(0.5, 1);
//    layer.colors = @[(__bridge id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor, (__bridge id)[UIColor colorWithWhite:1.0 alpha:0.16].CGColor, (__bridge id)[UIColor colorWithWhite:1.0 alpha:0.0].CGColor];
//    layer.locations = @[@(0), @(0.5f), @(1.0f)];
//    return layer;
//}
