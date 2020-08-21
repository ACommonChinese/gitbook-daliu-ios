//
//  main.m
//  runtime_section_simple
//
//  Created by 刘威振 on 2020/8/21.
//  Copyright © 2020 大刘. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>

// __DATA 是segment的名字, segment(段)下可包含很多section(区)
// section name: MY_SECTION_NAME
// value: 自定义字符串
char *xxxxxxxx __attribute((used, section("__DATA, MY_SECTION_NAME"))) = "Custom value";
//char *xxxxxxxx __attribute((used, section("SEG_DATA, MY_SECTION_NAME"))) = "Custom value";

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    // 此方法会被调用多次
    NSMutableArray *values = [NSMutableArray array];
    unsigned long size = 0;
    const char *sec_name = "MY_SECTION_NAME";
#ifndef __LP64__
    // getsectiondata(const struct mach_header_64 *mhp, const char *segname, const char *sectname, unsigned long *size)
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp, SEG_DATA, sec_name, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp; // 64位
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sec_name, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    if (counter > 0) {
        for (int idx = 0; idx < counter; ++idx) {
            char *string = (char *)memory[idx];
            NSString *str = [NSString stringWithUTF8String:string];
            if(!str)continue;
            [values addObject:str];
        }
        NSLog(@"----- %@", values);
    }
}

__attribute__((constructor)) // 使用它修饰后, initService()方法会在main函数之前得到调用
void initService() {
    NSLog(@"initService() 得到调用");
    _dyld_register_func_for_add_image(dyld_callback);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    }
    return 0;
}
