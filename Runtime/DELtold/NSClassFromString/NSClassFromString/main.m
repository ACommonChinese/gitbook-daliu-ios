//
//  main.m
//  NSClassFromString
//
//  Created by banma-1118 on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Class cls = NSClassFromString(@"Person");
        if (cls == nil) {
            NSLog(@"no person class");
        }
        else {
            NSLog(@"%@", cls);
        }
    }
    return 0;
}
