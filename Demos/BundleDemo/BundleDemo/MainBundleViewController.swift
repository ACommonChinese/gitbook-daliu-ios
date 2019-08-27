//
//  MainBundleViewController.swift
//  BundleDemo
//
//  Created by liuxing8807@126.com on 2019/8/26.
//  Copyright © 2019 daliu. All rights reserved.
//

import UIKit

class MainBundleViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "main bundle"
    }

    // 普通图片
    @IBAction func getImage(_ sender: Any) {
        // OK -- Bundle.main
        // self.imageView.image = UIImage(named: "1.png", in: Bundle.main, compatibleWith: nil)
        
        // OK -- Bundle(for: AnyClass)
        // self.imageView.image = UIImage(named: "1.png", in: Bundle(for: MainBundleViewController.self), compatibleWith: nil)
        
        // OK -- Bundle.main.path
        if let path = Bundle.main.path(forResource: "1", ofType: "png") {
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    // 在文件夹images中图片
    @IBAction func getImageInDir(_ sender: Any) {
        // OK -- Bundle.main
        // self.imageView.image = UIImage(named: "2.png", in: Bundle.main, compatibleWith: nil) // 不可写为images/2.png
        
        // OK -- Bundle.main.path
        // self.imageView.image = UIImage(named: "2.png", in: Bundle(for: MainBundleViewController.self), compatibleWith: nil) // 不可写为images/2.png
        
        // OK
        if let path = Bundle.main.path(forResource: "2", ofType: "png") { // 不可写为images/2
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    // 在bundle中的图片
    @IBAction func getImageInBundle(_ sender: Any) {
        // 新建文件夹，改后缀名，托入XCode
        // https://stackoverflow.com/questions/4888208/how-to-make-an-ios-asset-bundle
        /**OK
        let imagePath: String = Bundle.main.path(forResource: "MyBundle.bundle/1", ofType: "png")!
        self.imageView.image = UIImage(contentsOfFile: imagePath)
        */
        
        let bundlePath: String = Bundle.main.path(forResource: "MyBundle", ofType: "bundle")!
        if let bundle = Bundle(path: bundlePath) {
            // OK
            // self.imageView.image = UIImage(named: "1.png", in: bundle, compatibleWith: nil)
            
            let imagePath: String = bundle.path(forResource: "1", ofType: "png")!
            self.imageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
}
