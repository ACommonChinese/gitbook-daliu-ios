//
//  BMWavEncoder.h
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/12/2.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMWavEncoder : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;
- (void)encode;

@end

NS_ASSUME_NONNULL_END
