//
//  BaseViewController.m
//  UIPageViewControllerDemo
//
//  Created by liuweizhen on 2017/10/16.
//  Copyright © 2017年 LincomB. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    label.backgroundColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:60];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.center = self.view.center;
    label.text = [self title];
    
    [self.view addSubview:label];
}


@end
