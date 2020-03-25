//
//  BMShoppingViewController.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMShoppingViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@interface BMShoppingViewController ()

@end

@implementation BMShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Shopping";
    self.view.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
                                                green:arc4random() % 255 / 255.0
                                                 blue:arc4random() % 255 / 255.0
                                                alpha:1.0];
    
    // Right navigation item
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Test"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(handleTest:)];
}

- (void)handleTest:(UIBarButtonItem *)sender {
    dispatch_block_t block =
        (__bridge dispatch_block_t)(@module_call(BMModuleMessage.clazzMethod:, @"Class method."));
    if (block) {
        block();
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
