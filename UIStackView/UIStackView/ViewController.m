//
//  ViewController.m
//  UIStackView
//
//  Created by 刘威振 on 2020/5/15.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"
#import "DLView.h"

@interface ViewController ()

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLView *view = [[DLView alloc] initWithFrame:CGRectMake(20, 100, 300, 100)];
    [self.view addSubview:view];
    [view refreshWithOne:@"四月初八" two:@"寒\n露" three:@"庚子鼠年"];
}

@end
