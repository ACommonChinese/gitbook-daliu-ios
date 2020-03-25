//
//  BMModuleRouterModule.h
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMModuleRouterModule : NSObject

/// Target class reference
@property (nonatomic, strong) Class targetClass;

/// Cached module target instance, may be nil if shouldCache is NO
/// 缓存的module target实例，如果shouldCache为NO, 则返回nil
@property (nonatomic, strong) id target;

/// Should cache target instance
@property (nonatomic, assign) BOOL shouldCache;

- (instancetype)initWithClass:(Class)moduleClass args:(va_list)args;

@end

NS_ASSUME_NONNULL_END
