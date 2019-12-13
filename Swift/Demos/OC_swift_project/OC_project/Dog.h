//
//  Dog.h
//  OC_project
//
//  Created by daliu on 2019/12/6.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject

- (void)think;
- (void)eat:(NSString *)food;
+ (Dog *)getDog;

@end

NS_ASSUME_NONNULL_END
