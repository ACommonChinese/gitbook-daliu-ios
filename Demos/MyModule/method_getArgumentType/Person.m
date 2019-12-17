//
//  Person.m
//  method_getArgumentType
//
//  Created by liuxing8807@126.com-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)eat:(NSString *)food drink:(NSString *)water {
    NSLog(@"person eat: %@ and drink: %@", food, water);
}

+ (void)think {
    NSLog(@"person think");
}

@end
