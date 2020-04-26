//
//  CDShareVC.swift
//  LanHuPageViewControllerDemo
//
//  Created by liuweizhen on 2020/4/5.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

class CDShareVC: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    private let pageVC: UIPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing : 20])
    private let chapterVC: CDShareChapterVC = CDShareChapterVC.loadFromStoryboard()
    private let noteVC: CDShareNoteVC = CDShareNoteVC.loadFromStoryboard()
    private var subVcList:Array = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        self.subVcList.append(contentsOf: [chapterVC, noteVC])
        self.pageVC.delegate = self
        self.pageVC.dataSource = self
        // self.pageVC.setViewControllers(subVcList.first!, direction: .reverse, animated: false, completion: nil)
        self.pageVC.setViewControllers([subVcList[0]], direction: .reverse, animated: false, completion: nil)
        var frame = self.view.bounds
        var origin = frame.origin
        origin.y = 100
        frame.origin = origin
        self.pageVC.view.frame = frame
        pageVC.willMove(toParent: self)
        addChild(pageVC)
        self.view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: -
    
    // 返回上一个VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let ocArray = self.subVcList as NSArray
        let index = ocArray.index(of: viewController)
        if index <= 0 {
            return nil
        }
        return ocArray.object(at: index-1) as? UIViewController
    }
       
    // 下一个VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let ocArray = self.subVcList as NSArray
        let index = ocArray.index(of: viewController)
        if index >= ocArray.count-1 || index == NSNotFound {
            return nil
        }
        return subVcList[index+1]
    }
}
