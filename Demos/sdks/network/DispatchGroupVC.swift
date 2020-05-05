//
//  DispatchGroupVC.swift
//  network
//
//  Created by liuweizhen on 2020/5/5.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit
import Alamofire

class DispatchGroupVC: UITableViewController {
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    var img1Data: Data?
    var img2Data: Data?
    var img3Data: Data?
    
    public static func loadStoryboardVC<T: UIViewController>(name: String, cls: T.Type, bundle: Bundle, isInitial: Bool) -> T {
       let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
       if isInitial {
           return storyboard.instantiateInitialViewController() as! T
       } else {
           return storyboard.instantiateViewController(withIdentifier: name) as! T
       }
    }
    
    static func loadFromStoryboard() -> DispatchGroupVC {
        return loadStoryboardVC(name: "DispatchGroupVC", cls: DispatchGroupVC.self, bundle: Bundle.main, isInitial: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        self.tableView.rowHeight = 44.0
    }
    
    /// 一般模拟
    @IBAction func common(_ sender: Any) {
        // 创建调度组
        let group = DispatchGroup()
        // 创建队列
        // 这样创建的是串型队列, 任务一个接一个执行
        // let queue = DispatchQueue(label: "request_queue")
        // global全局队列, 任务间异步执行, 并非一个接一个执行
        let queue = DispatchQueue.global()
        
        // 模拟异步发送网络请求 A
        // 入组
        group.enter()
        print("A")
        queue.async {
            Thread.sleep(forTimeInterval: 1)
            print("接口 A 数据请求完成")
            // 出组
            group.leave()
        }
        
        // 模拟异步发送网络请求 B
        // 入组
        group.enter()
        print("B")
        queue.async {
            Thread.sleep(forTimeInterval: 6)
            print("接口 B 数据请求完成")
            // 出组
            group.leave()
        }
        
        group.enter()
        print("C")
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("接口 C 数据请求完成")
            // 出组
            group.leave()
        }
        
        print("我是最开始执行的，异步操作里的打印后执行")
        
        // 调度组里的任务都执行完毕
        group.notify(queue: queue) {
            print("A, B, C 的数据请求都已经完毕！, 开始合并两个接口的数据")
        }
        /**
        A
        B
        C
        我是最开始执行的，异步操作里的打印后执行
        接口 A 数据请求完成
        接口 C 数据请求完成
        接口 B 数据请求完成
        A, B, C 的数据请求都已经完毕！, 开始合并两个接口的数据
        */
    }
    
    /// 一般请求
    @IBAction func commonRequest(_ sender: Any) {
        // 从百度上找的图片资源
        let url1 = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588673015914&di=fae8e8773d376a6619c9c2cf5979aedb&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
        let url2 = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588673031791&di=ad47b5c9bfef03ee6bfe5d3a0af61e8b&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F14%2F75%2F01300000164186121366756803686.jpg"
        // let url3 =  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588673043471&di=89fd445339ca5891f05247bd83be3feb&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2Frushidao%2Fpics%2Fhv1%2F20%2F108%2F1744%2F113431160.jpg"
        
        let url3 = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588677902645&di=d2fab2922d9978408946ed68b3054b97&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180718%2Fdd5f833b034f4c00bb90a4809c066a99.jpeg"

        // 坑: alamofire5 使用 AF.request
        // https://stackoverflow.com/questions/28549832/module-alamofire-has-no-member-named-request
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        // 请求1
        group.enter()
        queue.async {
            AF.request(url1).responseData { (response) in
                print("请求1结束")
                // print(Thread.current.isMainThread) // 是主线程
                guard let data = response.data else {
                    group.leave()
                    return
                }
                // print(Thread.current.isMainThread) // 是主线程
                self.img1Data = data;
                group.leave()
                // self.img1.image = UIImage(data: data)
            }
        }
        
        // 请求2
        group.enter()
        queue.async {
            AF.request(url2).responseData { (response) in
                print("请求2结束")
                // print(Thread.current.isMainThread) // 是主线程
                guard let data = response.data else {
                   group.leave()
                   return
                }
                self.img2Data = data;
                group.leave()
            }
        }
        
        // 请求3
        group.enter()
        queue.async {
            AF.request(url3).responseData { (response) in
                // print(Thread.current.isMainThread) // 是主线程
                print("请求3结束")
                guard let data = response.data else {
                   group.leave()
                   return
                }
                self.img3Data = data;
                group.leave()
            }
        }
        
        // 3张图片请求全部结束后回调
        group.notify(queue: queue) {
            print("END")
            self.safeCallOnMainThread {
                if let d1 = self.img1Data {
                    self.img1.image = UIImage(data: d1)
                    self.img1Data = nil
                }
                if let d2 = self.img2Data {
                    self.img2.image = UIImage(data: d2)
                    self.img2Data = nil
                }
                if let d3 = self.img3Data {
                    self.img3.image = UIImage(data: d3)
                    self.img3Data = nil
                }
            }
        }
        
        // 由于Queue是全局队列, 所以依然是异步执行, 只是所有异步请求全结束后回调notify
        // 其中一次运行打印(再次运行可能是1, 2, 3 也可能是3, 2, 1 ...):
        // 请求2结束
        // 请求3结束
        // 请求1结束
        
        // 阻塞当前线程，直到group中的任务全部完成才进行返回
        // group.wait(timeout: DispatchTime.init(uptimeNanoseconds: DispatchTime.distantFuture))
    }
    
    func safeCallOnMainThread(_ block: () -> ()) {
        if Thread.current.isMainThread {
            block()
        } else {
            // https://stackoverflow.com/questions/44324595/difference-between-dispatchqueue-main-async-and-dispatchqueue-main-sync
            DispatchQueue.main.sync {
                block()
            }
        }
    }
    
    /// 请求间依赖
    @IBAction func dependencyRequest(_ sender: Any) {
        // https://blog.csdn.net/luobo140716/article/details/51480308
        // https://www.cnblogs.com/wangbinios/p/7383794.html
        // 假如第一个请求和第二个请求没有依赖关系, 可以异步请求
        // 第三个请求需要在第一个和第二个请求结束后再发起
        // 可以把前两个放在group中, 等前两个结束后再执行第三个, 也可以使用信号量处理
        // 这里我们使用信号量处理
        // OperationQueue有一个dependency的概念, 用于处理这种情况
        // 创建一个信号量，初始值为1
        // let semaphoreSignal = DispatchSemaphore(value: 1)
        // 表示信号量减1
        // semaphoreSignal.wait()
        // 表示信号量+1
        // semaphoreSignal.signal()

        let group = DispatchGroup()
        let queue = DispatchQueue.global()

        let url1 = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588673031791&di=ad47b5c9bfef03ee6bfe5d3a0af61e8b&imgtype=0&src=http%3A%2F%2Fa3.att.hudong.com%2F14%2F75%2F01300000164186121366756803686.jpg"
        let url2 = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588673015914&di=fae8e8773d376a6619c9c2cf5979aedb&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F64%2F76%2F20300001349415131407760417677.jpg"
        let url3 =  "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588673043471&di=89fd445339ca5891f05247bd83be3feb&imgtype=0&src=http%3A%2F%2Fimg1.gtimg.com%2Frushidao%2Fpics%2Fhv1%2F20%2F108%2F1744%2F113431160.jpg"
        
        let semaphore = DispatchSemaphore.init(value: 0)
        
        // 请求1
        group.enter()
        queue.async {
            self.getDataFromUrl(url1) { [unowned self] (data) in // Call to method 'getDataFromUrl' in closure requires explicit 'self.' to make capture semantics explicit
                self.safeCallOnMainThread {
                    self.img1.image = UIImage.init(data: data)
                    group.leave()
                    print("1 END")
                }
            }
        }
        
        queue.async {
            // 注: 由于AF.request返回的block是在主线程中, 因此此处用方法getDataFromUrl获取数据
            // 在主线程上进行信号量的wait操作非常危险, 会导致整个app卡死
            semaphore.wait()
            self.getDataFromUrl(url3) { [unowned self] (data) in
                print("3 END")
                self.safeCallOnMainThread {
                    self.img3.image = UIImage.init(data: data)
                    semaphore.signal() // 此句加不加对程序无影响, 但作为一个习惯, wait之后signal
                }
            }
        }
        
        group.enter()
        queue.async {
            self.getDataFromUrl(url2) { [unowned self] (data) in
                self.safeCallOnMainThread {
                    self.img2.image = UIImage.init(data: data)
                    group.leave()
                    print("2 END")
                }
            }
        }
        group.notify(queue: queue) {
            print("1 and 2 END")
            semaphore.signal() // 信号量值变为1
        }
        
        /**
         2 END
         1 END
         1 and 2 END
         3 END
         
         可能是2, 1, 3, 也可能是1, 2, 3, 但3总是会在最后
         */
    }
    
    func getDataFromUrl(_ urlStr: String, completion: (Data) -> ()) {
        let url: URL = URL.init(string: urlStr)!
        do {
            let data = try Data.init(contentsOf: url)
            completion(data)
        } catch let err {
            print(err)
        }
    }
}
