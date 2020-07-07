//
//  Person.m
//  WeatherAnimationModule
//
//  Created by 刘威振 on 2020/5/27.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)eat {
    NSLog(@"eat");
}

- (AFHTTPSessionManager *)getManager {
    return [AFHTTPSessionManager manager];
}

@end
