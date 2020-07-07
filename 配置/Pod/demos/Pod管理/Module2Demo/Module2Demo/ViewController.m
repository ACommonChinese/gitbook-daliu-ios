//
//  ViewController.m
//  Module2Demo
//
//  Created by 刘威振 on 2020/7/7.
//  Copyright © 2020 大刘. All rights reserved.
//

#import "ViewController.h"
#import <Module2/Module2.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Hello *hello = Hello.new;
    [hello say:@"中国"];
}


@end
