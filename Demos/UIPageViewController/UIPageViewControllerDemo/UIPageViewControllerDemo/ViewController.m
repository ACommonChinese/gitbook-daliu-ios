//
//  ViewController.m
//  UIPageViewControllerDemo
//
//  Created by liuweizhen on 2017/9/20.
//  Copyright © 2017年 LincomB. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "FiveViewController.h"

@interface ViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic) NSArray *contentControllers;
@property (nonatomic) UIPageViewController *pageController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentControllers = @[OneViewController.new, TwoViewController.new, ThreeViewController.new, FourViewController.new, FiveViewController.new];
   
    // 设置UIPageViewController的配置项
    // NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(0)};
    // NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    // 初始化UIPageViewControllerTransitionStylePageCurl
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    
    // 让UIPageViewController对象显示相应的页数据注意：
    // UIPageViewController要显示的页数据是NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据, 且 doubleSided = YES
    [self.pageController setViewControllers:@[self.contentControllers.firstObject] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // noted:
    
    // 设置UIPageViewController 尺寸
    self.pageController.view.frame = self.view.bounds;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
}

#pragma mark -  <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
// 返回上一个ViewController对象#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    if ((index - 1) < 0 || index == NSNotFound) {
        return nil;
    }
    return [self.contentControllers objectAtIndex:index - 1];
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.contentControllers indexOfObject:viewController];
    if (index >= self.contentControllers.count - 1 || index == NSNotFound) {
        return nil;
    }
    return self.contentControllers[index + 1];
}

@end
