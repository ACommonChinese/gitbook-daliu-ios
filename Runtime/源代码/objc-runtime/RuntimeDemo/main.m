//
//  main.m
//  RuntimeDemo
//
//  Created by bx on 2020/1/10.
//

#import <Foundation/Foundation.h>
#import "Student.h"
#import "message.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        Student *s = [Student new];
        
        // 实例方法
        [s walk];
        objc_msgSend(s, sel_registerName("walk"));
        /*以上验证，OC方法实质即发送消息*/

        // 类方法
        // 类方法调用错误
        // [s run];
        // objc_msgSend(s, sel_registerName("run"));
        
        [Student run];
        // 以下3种方法都可
        objc_msgSend(object_getClass(s), sel_registerName("run"));
        objc_msgSend(NSClassFromString(@"Student"), sel_registerName("run"));
        objc_msgSend(object_getClass([Student class]), @selector(run));
    }
    return 0;
}
