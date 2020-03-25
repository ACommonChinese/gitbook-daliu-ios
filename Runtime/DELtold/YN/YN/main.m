//
//  main.m
//  YN
//
//  Created by banma-1118 on 2019/9/26.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int index = 1;
        NSString *imgName = [NSString stringWithFormat:@"record_animate_%02d", index];
        NSLog(@"%@", imgName);
    }
    return 0;
}
