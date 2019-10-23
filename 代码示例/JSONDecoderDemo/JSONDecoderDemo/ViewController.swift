//
//  ViewController.swift
//  JSONDecoderDemo
//
//  Created by liuxing8807@126.com on 2019/10/23.
//  Copyright © 2019 liuweizhen. All rights reserved.
//  http://www.cocoachina.com/articles/23771

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Swift 4.0
        // An object that decodes instances of a data type from JSON objects.
        let button: UIButton = UIButton(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 200, height: 200)));
        button.addTarget(self, action: #selector(click), for: UIControl.Event.touchUpInside)
        button.backgroundColor = UIColor.red
        button.setTitle("Click me", for: UIControl.State.normal)
        self.view.addSubview(button)
    }

    @objc
    func click() {
        let landmarks: [Landmark] = JSONLoader.load("landmarkData.json")
        for landmark in landmarks {
            print(landmark.coordinates.latitude)
        }
    }
}

