//
//  LoginViewController.swift
//  Account
//
//  Created by liuxing8807@126.com on 2019/8/27.
//  Copyright © 2019 daliu. All rights reserved.
//
// 对于那些需要暴露出来，即在框架外部也能访问使用的类、方便、变量前面需要加上关键字 Public。如果还允许 override 和继承的话，可以使用 open 关键字
//

import UIKit

public class LoginViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    convenience init() {
        self.init(nibName: "LoginViewController", bundle: Bundle(for: LoginViewController.self))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    // 普通图片
    @IBAction func getImage(_ sender: Any) {
        // OK
        // self.imageView.image = UIImage(named: "1.jpeg", in: self.currentBundle(), compatibleWith: nil)
        
        // OK
        let path: String = self.currentBundle().path(forResource: "1", ofType: "jpeg")!
        self.imageView.image = UIImage(contentsOfFile: path)
    }
    
    // 在文件夹images中图片
    @IBAction func getImageInDir(_ sender: Any) {
        // OK
        // self.imageView.image = UIImage(named: "2.png", in: self.currentBundle(), compatibleWith: nil) // 不可写为images/2.png
        
        // OK
        if let path = self.currentBundle().path(forResource: "2", ofType: "png") { // 不可写为images/2
            self.imageView.image = UIImage(contentsOfFile: path)
        }
    }
    
    // 在bundle中的图片
    @IBAction func getImageInBundle(_ sender: Any) {
        /** // OK
        let imagePath:String! = self.currentBundle()?.path(forResource: "AccountBundle.bundle/1", ofType: "png")!
        self.imageView.image = UIImage(contentsOfFile: imagePath)
         */
        
        let bundlePath: String = self.currentBundle().path(forResource: "AccountBundle", ofType: "bundle")!
        if let bundle = Bundle(path: bundlePath) {
            // OK
            // self.imageView.image = UIImage(named: "1.png", in: bundle, compatibleWith: nil)
            
            // OK
            let imagePath: String = bundle.path(forResource: "1", ofType: "png")!
            self.imageView.image = UIImage(contentsOfFile: imagePath)
        }
    }
    
    // 在Account.xcassets中
    @IBAction func getImageInXcassets(_ sender: Any) {
        self.imageView.image = UIImage(named: "1.png", in: self.currentBundle(), compatibleWith: nil)
    }
    
    func currentBundle() -> Bundle! {
        return Bundle(for: LoginViewController.self)
    }
}
