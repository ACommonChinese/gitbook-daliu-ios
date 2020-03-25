//
//  BMModuleRouter.h
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMModuleRouterInvocation.h"
#import "BMModuleRouterModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface BMModuleRouter : NSObject

/// routers, 存放invocation对象
@property (nonatomic, strong) NSMutableDictionary<NSString *, BMModuleRouterInvocation *> *routers;

/// modules, 存放module对象
@property (nonatomic, strong) NSMutableDictionary<NSString *, BMModuleRouterModule *> *modules;

@end

NS_ASSUME_NONNULL_END
