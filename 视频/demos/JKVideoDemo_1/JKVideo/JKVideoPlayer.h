//
//  JKVideoPlayer.h
//  JKVideo
//
//  Created by liuweizhen on 2020/6/27.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface JKVideoPlayer : NSObject

+ (instancetype)sharedInstance;

- (void)playVideoWithUrl:(NSString *)videoUrl attachView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
