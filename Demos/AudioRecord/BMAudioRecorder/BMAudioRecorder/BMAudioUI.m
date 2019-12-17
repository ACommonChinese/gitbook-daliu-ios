//
//  BMAudioUI.m
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMAudioUI.h"
#import "BMAudioRecordViewController.h"

@implementation BMAudioUI

+ (void)show:(UINavigationController *)parentController {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    BMAudioRecordViewController *controller = [[BMAudioRecordViewController alloc] initWithNibName:@"BMAudioRecordViewController" bundle:bundle];
    [parentController pushViewController:controller animated:YES];
}

@end
