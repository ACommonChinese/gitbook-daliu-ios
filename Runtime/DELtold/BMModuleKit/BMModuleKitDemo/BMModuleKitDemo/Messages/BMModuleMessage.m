//
//  BMModuleMessage.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMModuleMessage.h"
#import "BMMessageViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@module(BMModuleMessage);
@implementation BMModuleMessage

- (BMMessageViewController *)messageViewController {
    return [[BMMessageViewController alloc] init];
}

- (void)sendMessage:(void(^)(NSString *message))callback {
    if (callback) {
        callback(@"Send message done.");
    }
}

+ (dispatch_block_t)clazzMethod:(NSString *)className {
    NSLog(@"########### class method: %@", className);
    return ^{
        NSLog(@"############ dipatch_block_t");
    };
}

@end
