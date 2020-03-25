//
//  BMModuleFriends.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMModuleFriends.h"
#import "BMFriendsViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@module(BMModuleFriends);
@implementation BMModuleFriends

- (BMFriendsViewController *)friendsViewController {
    return [[BMFriendsViewController alloc] init];
}

@end
