//
//  ViewController.m
//  LocalPodDemo
//
//  Created by 刘威振 on 2020/5/23.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "ViewController.h"
#import <ZZQRManager/ZZQRManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)test:(id)sender {
    ZZQRScanViewController *controller = [[ZZQRScanViewController alloc] init];
       //[controller setResultHandler:nil];
    [controller setResultHandler:^(ZZQRScanViewController *controller, NSString *result) {
       [controller dismissViewControllerAnimated:YES completion:^{
           NSLog(@"%@", result);
       }];
    }];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
