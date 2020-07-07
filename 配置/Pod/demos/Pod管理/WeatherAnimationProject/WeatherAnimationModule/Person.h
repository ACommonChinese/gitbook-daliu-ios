//
//  Person.h
//  WeatherAnimationModule
//
//  Created by 刘威振 on 2020/5/27.
//  Copyright © 2020 刘威振. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <AFNetworking.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

- (void)eat;
- (AFHTTPSessionManager *)getManager;

@end

NS_ASSUME_NONNULL_END
