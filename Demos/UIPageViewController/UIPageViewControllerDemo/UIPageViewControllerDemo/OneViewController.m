//
//  OneViewController.m
//  UIPageViewControllerDemo
//
//  Created by liuweizhen on 2017/9/20.
//  Copyright © 2017年 LincomB. All rights reserved.
//

#import "OneViewController.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"%s", __func__);
    
    NSLog(@"-- %@", NSStringFromCGRect(self.view.frame));
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, 100, 100)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
