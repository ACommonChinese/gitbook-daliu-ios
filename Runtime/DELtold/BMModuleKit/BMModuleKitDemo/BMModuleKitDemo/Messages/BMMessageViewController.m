//
//  BMMessageViewController.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMMessageViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@interface BMMessageViewController ()

@end

@implementation BMMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Messages";
    self.view.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
                                                green:arc4random() % 255 / 255.0
                                                 blue:arc4random() % 255 / 255.0
                                                alpha:1.0];
    
    // Right navigation item
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Detail"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(handleDetail:)];
}

- (void)handleDetail:(UIBarButtonItem *)sender {
    UIViewController *detailVC =
        (__bridge UIViewController *)(@module_call(BMDetailModule.detailViewController));
    if (detailVC && [detailVC isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:detailVC animated:YES];
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
