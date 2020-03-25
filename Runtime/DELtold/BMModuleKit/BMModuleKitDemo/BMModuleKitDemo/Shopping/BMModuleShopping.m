//
//  BMModuleShopping.m
//  BMModuleKitDemo
//
//  Created by Chris on 2019/2/19.
//  Copyright © 2019 banma-593. All rights reserved.
//

#import "BMModuleShopping.h"
#import "BMShoppingViewController.h"
#import <BMModuleKit/BMModuleKit.h>

@module(BMModuleShopping);
@implementation BMModuleShopping

- (BMShoppingViewController *)shoppingViewController {
    return [[BMShoppingViewController alloc] init];
}

- (NSInteger)test:(int)i
                f:(float)f
                d:(double)d
                s:(NSString *)s
                a:(NSArray *)arr
                d:(NSDictionary *)dict {
    NSLog(@"##### i: %d, f: %f, d: %f, s: %@, arr: %@, dict: %@", i, f, d, s, arr ,dict);
    return 2019;
}

@end
