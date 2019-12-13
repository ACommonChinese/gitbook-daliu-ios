//
//  Dog.m
//  OC_project
//
//  Created by daliu on 2019/12/6.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "Dog.h"

@implementation Dog

- (void)think {
    NSLog(@"Dog can think, but it's different with person's think");
}

- (void)eat:(NSString *)food {
    NSLog(@"%@", [NSString stringWithFormat:@"dog can eat: %@, it's important", food]);
}

+ (Dog *)getDog {
    return nil;
}

@end
