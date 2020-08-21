//
//  JKBUADService.m
//  runtime_section
//
//  Created by 刘威振 on 2020/8/14.
//  Copyright © 2020 大刘. All rights reserved.
//

#import "JKBUADService.h"
#import "JKADServiceRegisterDefines.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>

/**
 
 JKBUADService
 JKBUADService2
 */

JKADServiceRegist(JKBUADService1)
JKADServiceRegist(JKBUADService2)
JKADServiceRegist(JKBUADService3)
JKADServiceRegist(JKBUADService4)
JKADServiceRegist(JKBUADService5)
@implementation JKBUADService

@end

NSArray<NSString *>* JKReadConfiguration(char *sectionName,const struct mach_header *mhp) {
     NSMutableArray *configs = [NSMutableArray array];
        unsigned long size = 0;
    #ifndef __LP64__
        uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
    #else
        const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp; // 64位
        uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
    #endif

    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        NSLog(@"1. %@", str); // JKBUADService
        if(str) [configs addObject:str];
    }

    return configs;
}

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    //register services
    NSArray<NSString *> *services = JKReadConfiguration(JKADServiceSectName,mhp);
    for (NSString *serviceName in services) {
        Class cls;
        if (serviceName) {
            cls = NSClassFromString(serviceName);
            if (cls) {
                //[[JKADServiceManager sharedManager] registerADServiceWithClass:cls];
                NSLog(@"2. %@", cls); // JKBUADService
            }
        }
    }
}

__attribute__((constructor)) // main之前调用
void initJKADService() {
    _dyld_register_func_for_add_image(dyld_callback);
}
