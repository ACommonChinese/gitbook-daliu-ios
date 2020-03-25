//
//  Person.h
//  MimickBMModule
//
//  Created by banma-1118 on 2019/9/23.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

+ (instancetype)personWithName:(NSString *)name age:(NSInteger)age;

@end

NS_ASSUME_NONNULL_END
