//
//  ViewController.m
//  AudioRecord
//
//  Created by liuxing8807@126.com on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//  https://www.jianshu.com/p/fb0e5fb71b3c

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <BMAudioRecorder/BMAudioRecorder.h>

@interface ViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Audio demo";
    [self configSession];
}

/// 配置session
- (void)configSession {
    // 一般session的配置可以写在AppDelegate中
    // session: 和系统交互，用以说明如何使用audio
      _session = [AVAudioSession sharedInstance];
      NSError *activeError = nil;
      BOOL active = [_session setActive:YES error:&activeError];
      if (!active || activeError) {
          NSLog(@"active session error: %@", activeError);
          return;
      }
      // NSArray<NSString *> *availableCategories = _session.availableCategories;
      // NSLog(@"%@", availableCategories);
      /**
      (
          AVAudioSessionCategoryAmbient,
          AVAudioSessionCategorySoloAmbient,
          AVAudioSessionCategoryPlayback, // 混音
          AVAudioSessionCategoryRecord, // 录音
          AVAudioSessionCategoryPlayAndRecord, // 录音和播放
          AVAudioSessionCategoryMultiRoute
      )
       */
      NSError *error = nil;
      // [_session setCategory:AVAudioSessionCategoryRecord error:&error];
      BOOL isSuccess = [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
      if (!isSuccess || error) {
          NSLog(@"set category record fail: %@", error);
          return;
      }
}

/// MARK: 开始录音
- (void)startRecord {
    // recorder: 录音器
    NSDictionary *settings = @{
        AVSampleRateKey : @(8000.0),
        AVFormatIDKey : @(kAudioFormatLinearPCM),
        AVLinearPCMBitDepthKey : @(16),
        AVNumberOfChannelsKey : @(1),
        AVEncoderAudioQualityKey : @(AVAudioQualityMax)
    };
    NSError *initError;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[self fileUrl] settings:settings error:&initError];
    if (initError || !_recorder) {
        NSLog(@"init recorder error: %@", initError);
        return;
    }
    // 计量器
    _recorder.meteringEnabled = YES;
    [_recorder prepareToRecord];
    [_recorder record];
}

/// MARK: 停止录音
- (void)stopRecord {
    if ([_recorder isRecording]) {
        [_recorder stop];
    }
}

- (void)startPlay {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = self.filePath;
    if (![fileManager fileExistsAtPath:filePath]) {
        NSLog(@"录音文件不存在");
        return;
    }
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    if (!_player || error) {
        NSLog(@"init audo player error: %@", error);
    }
    _player.delegate = self;
    [_player play];
}

- (void)pausePlay {

}

- (void)stopPlay {
    
}

- (NSURL *)fileUrl {
    NSDateFormatter *nameforamt = [NSDateFormatter new];
    [nameforamt setDateFormat:@"yyyyMdHms"];
    NSString *dateStr = [nameforamt stringFromDate:[NSDate date]];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", dateStr]];
    self.filePath = filePath;
    return [NSURL fileURLWithPath:filePath];
}

// MARK: <AVAudioPlayerDelegate>
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"audio player end");
}


- (IBAction)start:(id)sender {
    [BMAudioUI show:self.navigationController];
}

@end
