//
//  ViewController.m
//  MimickBMModule
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "ViewController.h"
#import "SubDemo.h"

// 定义AAA为一个block执行的结果
// #define AAA ^void * { NSLog(@"Hello"); return nil; }()
// 调用：void *a = AAA;

#define module_stringify(...) @#__VA_ARGS__

@interface ViewController ()

@end

@implementation ViewController

NSString * sayhello() {
    NSString *hello = @"Hello World!";
    NSLog(@"%@", hello);
    return hello;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SubDemo *demo = [[SubDemo alloc] init];
    [demo demo];
}

@end
