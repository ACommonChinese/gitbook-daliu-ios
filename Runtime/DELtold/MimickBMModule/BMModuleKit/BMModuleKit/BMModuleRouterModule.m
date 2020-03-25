//
//  BMModuleRouterModule.m
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMModuleRouterModule.h"

@implementation BMModuleRouterModule

- (instancetype)initWithClass:(Class)targetClass args:(va_list)args {
    self = [super init];
    if (self) {
        _targetClass = targetClass;
        _shouldCache = va_arg(args, int);
    }
    return self;
}

- (id)target {
    // 如果_target不存在，并且需要缓存，则新建target对象
    if (_shouldCache && !_target) {
        _target = [[self.targetClass alloc] init];
    }
    return _target;
}

@end
