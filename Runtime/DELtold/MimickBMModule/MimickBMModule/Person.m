//
//  Person.m
//  MimickBMModule
//
//  Created by banma-1118 on 2019/9/23.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age {
    Person *p = [[self alloc] init];
    p.name = name;
    p.age = age;
    return p;
}

@end
