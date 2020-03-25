//
//  BMDetailModule.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMDetailModule.h"
#import "BMDetailViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@module(BMDetailModule);
@implementation BMDetailModule

- (BMDetailViewController *)detailViewController {
    return [[BMDetailViewController alloc] init];
}

@end
