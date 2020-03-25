//
//  Router.h
//  method_getArgumentType
//
//  Created by banma-1118 on 2019/9/24.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

// 示例：module_call(Person.eat:drink:, @"food", @"water")
#define module_call(URL, ...) [[Router sharedRouter] route: @#URL,  ## __VA_ARGS__, nil]

@interface Router : NSObject

- (void *)route:(NSString *)url, ...;
+ (instancetype)sharedRouter;

@end
