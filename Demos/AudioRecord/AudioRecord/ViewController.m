//
//  ViewController.m
//  AudioRecord
//
//  Created by liuxing8807@126.com on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//  https://www.jianshu.com/p/fb0e5fb71b3c

#import "ViewController.h"
#import <BMAudioRecorder/BMAudioRecorder.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Audio demo";
}

- (IBAction)start:(id)sender {
    [BMAudioUI show:self.navigationController];
}

@end
