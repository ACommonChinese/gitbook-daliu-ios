//
//  BMDetailViewController.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMDetailViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@interface BMDetailViewController ()

@end

@implementation BMDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Detail";
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
    NSNumber *number = (__bridge NSNumber *)(@module_call(BMModuleShopping.test:f:d:s:a:d:,
                                                          199,
                                                          2.89,
                                                          10.00,
                                                          @"Hello",
                                                          @[@"A", @"B", @"C"],
                                                          @{@"1":@"Hello", @"2": @"Test"}));
    NSLog(@"############# I got a number: %@", number);
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
