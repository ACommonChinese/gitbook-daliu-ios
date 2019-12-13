//
//  Person.swift
//  OC_project
//
//  Created by daliu on 2019/12/6.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

import Foundation

// 和java不同，这里public的类名Person和文件名可以不一样，但作为习惯，一般和文件名写成一样
// public可以省略，外面同样可以调得到
// 如果要OC调用到这个Swift类，@objc不可省略，而且这个类要直接或间接继承于NSObject
@objc public class Person : NSObject {
    // 为了让OC调用，方法同样需要@objc标示
    @objc
    func think() -> Void {
        print("person can think, it's important.")
    }
    
    @objc
    func eat() -> Void {
        print("person can eat, it's important.")
    }
    
    @objc
    func drink(_ water: String) -> Void {
        print("person can drink \(water), it's important")
    }
    
    @objc
    func dogThink() -> Void {
//        let dog: Dog = Dog()
//        dog.think()
       
        if let _ = Optional(Dog.getDog()) {
            print("yes")
        }
        else {
            print("no")
        }
    }

    @objc
    func dogEat(_ food: String) -> Void {
        let dog: Dog = Dog()
        dog.eat(food)
    }
}
