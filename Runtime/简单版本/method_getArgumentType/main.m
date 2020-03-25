//
//  main.m
//  method_getArgumentType
//
//  Created by banma-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Router.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Person.eat:drink: 作为key  invocation作为对象
        module_call(Person.eat:drink:, @"food", @"water");
        module_call(Person.think);
    }
    return 0;
}
