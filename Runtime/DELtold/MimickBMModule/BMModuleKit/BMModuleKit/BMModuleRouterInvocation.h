//
//  BMModuleRouterInvocation.h
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMModuleRouterModule.h"

typedef NS_ENUM(NSInteger, BMModuleRouterInvocationType) {
    /// Instance method
    BMModuleRouterInvocationTypeInstance,
    /// Class method
    BMModuleRouterInvocationTypeClass,
};

NS_ASSUME_NONNULL_BEGIN

@interface BMModuleRouterInvocation : NSObject

/// A back-pointer to the module
@property (nonatomic, assign) BMModuleRouterModule *module;

/// Method instance
@property (nonatomic, assign) Method method;

/// Ie, instance or class type
@property (nonatomic, assign) BMModuleRouterInvocationType invocationType;

/// Argument count
@property (nonatomic, assign) unsigned int argumentCount;

/// Argument types
@property (nonatomic, assign) const char **argumentTypes;

/// Invoke:
- (void *)invoke:(va_list)args;

@end

NS_ASSUME_NONNULL_END
