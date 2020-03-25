//
//  BMModuleKit.h
//  BMModuleKit
//
//  Created by banma-1118 on 2019/9/19.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for BMModuleKit.
FOUNDATION_EXPORT double BMModuleKitVersionNumber;

//! Project version string for BMModuleKit.
FOUNDATION_EXPORT const unsigned char BMModuleKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BMModuleKit/PublicHeader.h>

// In this header, you should import all the public headers of your framework using statements like #import <BMModuleKit/PublicHeader.h>
#if __has_include(<BMModuleKit/BMModuleKit.h>)

#import <BMModuleKit/BMModuleRouter.h>
#import <BMModuleKit/BMModuleRouterModule.h>
#import <BMModuleKit/BMModuleRouterInvocation.h>

#else

#import "BMModuleRouter.h"
#import "BMModuleRouterModule.h.h"
#import "BMModuleRouterInvocation.h"

#endif
