//
//  ViewController.swift
//  SwiftException
//
//  Created by banma-1118 on 2019/12/13.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

import UIKit

/// Swift所有的异常都继承于Error
enum CustomError : Error {
    case exception_1
    case exception_2
    case exception_3
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = try? self.sayHello(type: 4)
        if let s = str {
            print(s)
        }
    }
 
    func sayHello(type: Int) throws -> String {
        
        /// 注意defer方法的位置要在throw之前
        defer {
            print("just as finally")
        }

        if type == 1 {
            throw CustomError.exception_1
        }
        if type == 2 {
            throw CustomError.exception_2
        }
        if type == 3 {
            throw CustomError.exception_3
        }
        
        return "Hello world!"
    }
}

