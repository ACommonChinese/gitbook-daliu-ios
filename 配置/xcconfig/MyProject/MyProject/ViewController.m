//
//  ViewController.m
//  MyProject
//
//  Created by 刘威振 on 2020/4/29.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    NSLog(@"%@", [userDefault objectForKey:@"BASE_URL"]);
//    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", BasicURL, @"question"];
    NSLog(@"%@", urlStr);
    
    NSString *baseUrl = [[NSBundle mainBundle].infoDictionary objectForKey:@"BasicURL"];
    NSLog(@"%@", baseUrl); // @"http:\/\/test2api.xiaowei.com/rq"
}

@end
