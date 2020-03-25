//
//  BMModuleProfile.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMModuleProfile.h"
#import "BMProfileViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@module(BMModuleProfile);
@implementation BMModuleProfile

- (BMProfileViewController *)profileViewController {
    return [[BMProfileViewController alloc] init];
}

@end
