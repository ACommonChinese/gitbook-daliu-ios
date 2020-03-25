//
//  main.m
//  sizeof
//
//  Created by banma-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        char *type = (char *)malloc(128);
        NSLog(@"%lu", sizeof(type));
        char *array[3];
        array[0] = "hello";
        array[1] = "world";
        array[2] = "china!";
        for (int i = 0; i < 3; i++) {
            printf("%s\n", array[i]);
        }
    }
    return 0;
}
