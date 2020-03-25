//
//  BMFriendsViewController.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMFriendsViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@interface BMFriendsViewController ()

@end

@implementation BMFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Friends";
    self.view.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0
                                                green:arc4random() % 255 / 255.0
                                                 blue:arc4random() % 255 / 255.0
                                                alpha:1.0];
    
    // Right navigation item
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Send"
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(handleSendMessage:)];
}

- (void)handleSendMessage:(UIBarButtonItem *)sender {
    @module_call(BMModuleMessage.sendMessage:, ^(NSString *message){
        NSLog(@"############# test send message: %@", message);
    });
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
