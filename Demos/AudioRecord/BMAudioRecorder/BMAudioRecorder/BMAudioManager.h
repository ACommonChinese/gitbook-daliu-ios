//
//  BMAudioManager.h
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMAudioManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)isRecording;
- (void)startRecord;
- (void)pauseRecord;
- (void)finishRecord;

- (void)startPlay;
- (void)pausePlay;
- (void)stopPlay;

- (AVAudioRecorder *)recorder;
- (NSURL *)fileUrl;

@end

NS_ASSUME_NONNULL_END
