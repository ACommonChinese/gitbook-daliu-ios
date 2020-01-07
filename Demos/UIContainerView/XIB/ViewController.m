//
//  ViewController.m
//  XIB
//
//  Created by liuxing8807@126.com on 2019/12/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"

@interface ViewController ()

@property (nonatomic, strong) OneViewController *oneVC;
@property (nonatomic, strong) TwoViewController *twoVC;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oneView.hidden = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"one"]) {
        OneViewController *controller = [segue destinationViewController];
        self.oneVC = controller;
    }
    else if ([segue.identifier isEqualToString:@"two"]) {
        TwoViewController *controller = [segue destinationViewController];
        self.twoVC = controller;
    }
}

@end
