//
//  Invocation.h
//  method_getArgumentType
//
//  Created by liuxing8807@126.com-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZZModuleRouterInvocationType) {
    ZZModuleRouterInvocationTypeInstance,
    ZZModuleRouterInvocationTypeClass,
};

@interface Invocation : NSObject

@property (nonatomic, strong) Class targetClass;
@property (nonatomic, assign) unsigned int argumentCount;
@property (nonatomic, copy) NSString *selectorName;
@property (nonatomic, assign) const char **argumentTypes;
@property (nonatomic, assign) ZZModuleRouterInvocationType invocationType;

- (void *)invoke:(va_list)args;

@end
