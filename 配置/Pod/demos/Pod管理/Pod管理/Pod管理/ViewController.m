//
//  ViewController.m
//  Pod管理
//
//  Created by 刘威振 on 2020/5/27.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"
#import <WeatherAnimationModule/WeatherAnimationModule.h>
#import <Module2/Module2.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = Person.new;
    [p eat];
    
    AFHTTPSessionManager *manager = [p getManager];
    NSLog(@"%@", manager);
    
    Hello *hello = Hello.new;
    [hello say:@"祖国是什么? 祖国是人民."];
}

@end
