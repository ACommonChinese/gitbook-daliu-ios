//
//  BMModuleRouterInvocation.m
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMModuleRouterInvocation.h"

@implementation BMModuleRouterInvocation

- (instancetype)init {
    self = [super init];
    if (self) {
        _argumentTypes = nil;
    }
    return self;
}

//- (void *)invoke:(va_list)args {
//    // Create a module instance
//    id target = self.module.target ?: [[self.module.targetClass alloc] init]; // TODO://如果module是单例？
//}

@end
