//
//  ViewController.m
//  OC_project
//
//  Created by daliu on 2019/12/6.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "ViewController.h"
#import "OC_project-Swift.h" // 让OC可以调Swift, 格式：工程名-Swift.h

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 依赖于Apple自动生成的‘工程名-Swift.h’文件，本示例中是：OC_project-Swift.h
    // 其实在这个文件中声明了一些Swift到OC的转换后方法，因此我们可以以OC的调用方式调用Swift方法
    Person *p = [[Person alloc] init];
//    NSLog(@"%@", p);
    [p dogThink];
//    [p eat];
//    [p drink:@"咖啡"];
//    [p dogThink]; // 添加
//    [p dogEat:@"狗粮"]; // 添加
}

@end
