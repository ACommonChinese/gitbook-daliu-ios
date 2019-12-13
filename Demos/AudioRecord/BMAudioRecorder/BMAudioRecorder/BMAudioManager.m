//
//  BMAudioManager.m
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMAudioManager.h"

@interface BMAudioManager () <AVAudioRecorderDelegate> {
    /// 录音器
    AVAudioRecorder *_recorder;
    /// 播放器
    AVAudioPlayer *_player;
    /// 录音文件沙盒地址
    NSURL *_recordUrl;
}

@end

@implementation BMAudioManager

// MARK: Initial

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static BMAudioManager *_manager;
    dispatch_once(&onceToken, ^{
        _manager = [[BMAudioManager alloc] init];
    });
    return _manager;
}

- (void)checkPermission:(void(^)(BOOL permission))permission {
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            NSLog(@"%@", [NSThread currentThread]);
            if (granted) {
                permission(YES);
            }else{
                permission(NO);
            }
        }];
    }
}

// MARK: Getters

- (AVAudioRecorder *)recorder {
    return [self getRecorder];
}

- (NSURL *)fileUrl {
    return [self getRecordUrl];
}

- (AVAudioRecorder *)getRecorder {
    if (!_recorder) {
        NSDictionary *settings = @{
            // 录音格式
            AVFormatIDKey : @(kAudioFormatLinearPCM), // kAudioFormatMPEG4AAC
            // 录音采样速率
            // (单位：Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量和音频文件的大小）
            AVSampleRateKey : @(44100),
            // 录音通道:AVNumberOfChannelsKey 1/2
            // AVNumberOfChannelsKey : @(2),
            AVNumberOfChannelsKey : @(1),
            // 设置线性采样位数  8、16、24、32
            AVLinearPCMBitDepthKey : @(16),
            // 录音质量
            AVEncoderAudioQualityKey : @(AVAudioQualityHigh),
        };
        NSError *error = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:[self getRecordUrl] settings:settings error:&error];
        if (error) {
            NSLog(@"创建recorder错误：%@", error);
        }
        // 开启音量检测
        _recorder.meteringEnabled = YES;
        _recorder.delegate = self;
    }
    return _recorder;
}

- (AVAudioPlayer *)getPlayer {
    if (!_player) {
        NSError *error = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getRecordUrl] error:&error];
        if (!_player || error) {
            NSLog(@"_player init error: %@", error);
            _player = nil;
            return nil;
        }
    }
    return _player;
}

- (NSURL *)getRecordUrl {
    if (!_recordUrl) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
               _recordUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/wen_qing.lpcm", filePath]];
    }
    NSLog(@"recorUrl: %@", _recordUrl);
    return _recordUrl;
}

// MARK: Public APIs

- (void)startRecord {
    __weak __typeof(self) weakSelf = self;
    [self checkPermission:^(BOOL permission) {
        if (permission) {
            [weakSelf _startRecord];
        }
    }];
}

- (void)_startRecord {
    if ([self getRecorder].isRecording) {
        NSLog(@"正在录音中，请先停止");
        return;
    }
    [[self getRecorder] record];
}

- (void)pauseRecord {
    [[self getRecorder] pause];
}

- (void)finishRecord {
    [[self getRecorder] stop];
}

- (void)startPlay {
    __weak __typeof(self) weakSelf = self;
    [self checkPermission:^(BOOL permission) {
        if (permission) {
            [weakSelf _startPlay];
        }
    }];
}

- (void)_startPlay {
    [[self getPlayer] play];
}

- (void)pausePlay {
    [[self getPlayer] pause];
}

- (void)stopPlay {
    [[self getPlayer] stop];
}

- (BOOL)isRecording {
    if (_recorder == nil) return NO;
    return _recorder.isRecording;
}

- (void)updateMeters {
    if (_recorder == nil) return;
    [_recorder updateMeters];
}

// MARK: <AVAudioRecorderDelegate>

@end
