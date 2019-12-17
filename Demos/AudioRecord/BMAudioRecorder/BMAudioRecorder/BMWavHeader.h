//
//  BMWavHeader.h
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/12/2.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMWavHeader : NSObject

@property (nonatomic, assign) UInt32 fileLength;
@property (nonatomic, assign) UInt32 fmtHeaderLength;
@property (nonatomic, assign) UInt16 formatTag;
/// one channel is mono and two channels are stereo
@property (nonatomic, assign) UInt16 channels;
@property (nonatomic, assign) UInt32 samplesPerSec;
@property (nonatomic, assign) UInt32 avgBytesPerSec;
@property (nonatomic, assign) UInt16 blockAlign;
@property (nonatomic, assign) UInt16 bitsPerSample;
@property (nonatomic, assign) UInt32 dataHeaderLength;

- (NSData *)getData;

@end

NS_ASSUME_NONNULL_END
