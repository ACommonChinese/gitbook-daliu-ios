///***************************************************************************************
// *
// *  Project:        BMModuleKit
// *
// *  Copyright ©     2014-2019 Banma Technologies Co.,Ltd
// *                  All rights reserved.
// *
// *  This software is supplied only under the terms of a license agreement,
// *  nondisclosure agreement or other written agreement with Banma Technologies
// *  Co.,Ltd. Use, redistribution or other disclosure of any parts of this
// *  software is prohibited except in accordance with the terms of such written
// *  agreement with Banma Technologies Co.,Ltd. This software is confidential
// *  and proprietary information of Banma Technologies Co.,Ltd.
// *
// ***************************************************************************************
// *
// *  Header Name: BMModuleKit.h
// *
// *  General Description: Copyright and file header.
// *
// *  Created by Chris on 2019/2/19.
// *
// ****************************************************************************************/

#import <UIKit/UIKit.h>

//! Project version number for BMModuleKit.
FOUNDATION_EXPORT double BMModuleKitVersionNumber;

//! Project version string for BMModuleKit.
FOUNDATION_EXPORT const unsigned char BMModuleKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BMModuleKit/PublicHeader.h>
#if __has_include(<BMModuleKit/BMModuleKit.h>)
#   import <BMModuleKit/BMModuleRouter.h>
#else
#   import "BMModuleRouter.h"
#endif

#ifndef module

#define module_stringify(...) @#__VA_ARGS__

#define module_class_from_string(...) (0).boolValue ? nil : ^Class {\
    return NSClassFromString(@#__VA_ARGS__);\
}()

#define module_selector_from_string(...) (0).boolValue ? nil : ^SEL {\
    return NSSelectorFromString(@#__VA_ARGS__);\
}()

#define module_router() (0).boolValue ? nil : ^id {\
    Class routerClass = @module_class_from_string(BMModuleRouter);\
    if (routerClass) {\
        SEL sel = @module_selector_from_string(sharedRouter);\
        if (sel && [routerClass respondsToSelector:sel]) {\
            IMP imp = [routerClass methodForSelector:sel];\
            return ((id (*)(id, SEL))imp)(routerClass, sel);\
        }\
    } return nil;\
}()

#define module(T, ...) interface BMModule_##T : NSObject @end @implementation BMModule_##T + (void)load {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        [super load];\
        Class targetClass = @module_class_from_string(T);\
        if (targetClass) {\
            id router = @module_router();\
            if (router) {\
                SEL sel = @module_selector_from_string(addModule:);\
                if (sel && [router respondsToSelector:sel]) {\
                    IMP imp = [router methodForSelector:sel];\
                    ((void (*)(id, SEL, id, ...))imp)\
                        (router, sel, targetClass, ## __VA_ARGS__, nil);\
                }\
            }\
        }\
    });\
} @end

#define module_call(URL, ...) (0).boolValue ? nil : ^void * {\
    id router = @module_router();\
    if (router) {\
        SEL sel = @module_selector_from_string(route:);\
        if (sel && [router respondsToSelector:sel]) {\
            IMP imp = [router methodForSelector:sel];\
            return ((void * (*)(id, SEL, id, ...))imp)(router, sel, @#URL, ## __VA_ARGS__, nil);\
        }\
    } return nil;\
}()

#define module_call2(URL, R, ...) (0).boolValue ? (R)0 : ^R {\
    id router = @module_router();\
    if (router) {\
        SEL sel = @module_selector_from_string(target:);\
        if (sel && [router respondsToSelector:sel]) {\
            IMP imp = [router methodForSelector:sel];\
            id target = ((id (*)(id, SEL, id))imp)(router, sel, @#URL);\
            if (target) {\
                NSArray<NSString *> *parts = [@#URL componentsSeparatedByString:module_stringify(.)];\
                if (parts && parts.count == 2) {\
                    SEL sel = NSSelectorFromString(parts[1]);\
                    if (sel && [target respondsToSelector:sel]) {\
                        IMP imp = [target methodForSelector:sel];\
                        return ((R (*)(id, SEL, ...))imp)(target, sel, ## __VA_ARGS__, nil);\
                    }\
                }\
            }\
        }\
    } return (R)0;\
}()

#endif

