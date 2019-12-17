//
//  BMAudioRecordViewController.m
//  BMAudioRecorder
//
//  Created by liuxing8807@126.com on 2019/9/25.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

#import "BMAudioRecordViewController.h"
#import "BMWavEncoder.h"
#import <AVFoundation/AVFoundation.h>

#define kRecordAudioFile @"myRecord.caf"

@interface BMAudioRecordViewController ()

/// 音量图片
@property (weak, nonatomic) IBOutlet UIImageView *volumeImageView;
/// 开始 / 暂停按钮
@property (weak, nonatomic) IBOutlet UIButton *playButton;
/// 开始 / 暂停文本
@property (weak, nonatomic) IBOutlet UILabel *playButtonLabel;
/// 停止文本
@property (weak, nonatomic) IBOutlet UILabel *stopButtonLabel;
/// 停止按钮
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
/// 定时器
@property (nonatomic, strong) NSTimer *timer;

/// 录音器
@property (nonatomic, strong) AVAudioRecorder *recorder;
/// 播放器
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BMAudioRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self refreshStateInitial];
}

- (void)initUI {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Convert" style:UIBarButtonItemStylePlain target:self action:@selector(toConvert)];
    
    [self checkPermission:^(BOOL permission) {
        
    }];
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

- (void)toConvert {
    NSURL *recordUrl = [self getRecordUrl];
    NSString *filePath = [recordUrl path];
    NSLog(@"origin file path: %@", filePath);
    NSString *destPath = [[filePath stringByDeletingPathExtension] stringByAppendingString:@".wav"];
    NSLog(@"dest path: %@", destPath);
    BMWavEncoder *encoder = [[BMWavEncoder alloc] initWithFilePath:filePath];
    [encoder encode];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [NSString stringWithFormat:@"srcPath file not exitst error: %@", filePath];
        return ;
    }
    NSError *error = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:&error];
    if (!attributes || error) {
        NSLog(@"get file attribute error %@", [NSString stringWithFormat:@"%@", error]);
        return;
    }
    long totalSize = (int)[attributes fileSize];
    NSLog(@"====> %ld字节", totalSize);
    NSLog(@"====> %ldK", totalSize/1024);
    NSLog(@"====> %ldM", totalSize/1024/1024);
    NSLog(@"====> %ldM字节", totalSize/1024/1024);
    NSLog(@"====> %ldM字节", totalSize/1024/1024/5);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"LPCM转WAV转换成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopTimer];
}

// MARK: Actions

- (void)viewWillDisappear:(BOOL)animated {
    [self stopTimer];
}

/// 录音 / 暂停
- (IBAction)playPause:(UIButton *)button {
    if (button.isSelected) {
        // 暂停
        [self refreshStatePause];
        [self pause];
    } else {
        // 录音
        [self record];
        [self refreshStateRecord];
    }
}

- (void)play {
    NSError *error = nil;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getRecordUrl] error:&error];
    if (self.player == nil || error) {
        NSLog(@"Error prepare player!");
    }
    BOOL prepare = [self.player prepareToPlay];
    NSLog(@"%@", prepare?@"准备成功":@"准备失败");
    [self.player play];
}

/// 录音
- (void)record {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL flag = [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    if (!flag) {
        NSLog(@"Set AudioSession category AVAudioSessionCategoryRecord fail");
        return;
    }
    [audioSession setActive:YES error:nil];
    
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
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[self getRecordUrl] settings:settings error:&error];
    if (!self.recorder || error) {
       NSLog(@"创建recorder错误：%@", error);
    }
    // 开启音量检测
    self.recorder.meteringEnabled = YES;
    // self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    [self.recorder record];
}

- (NSURL *)getRecordUrl {
    // https://stackoverflow.com/questions/6881938/how-to-save-images-and-recorded-files-in-temp-directory
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    urlStr = [urlStr stringByAppendingPathComponent:kRecordAudioFile];
    return [NSURL fileURLWithPath:urlStr];
}

/// 暂停
- (void)pause {
    
}

/// 停止
- (IBAction)stop:(UIButton *)button {
    [self refreshStateStop];
    
    [self.recorder stop];
    
    UIAlertController *alet = [UIAlertController alertControllerWithTitle:@"录制完成，是否播放" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alet addAction:[UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self play];
    }]];
    [self presentViewController:alet animated:YES completion:nil];
}

// MARK: Refresh UI

- (BOOL)refreshStateInitial {
    self.volumeImageView.image = [self imageRecord:1];
    // [self.closeButton setBackgroundImage:[self imageClose] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[self imageRecordPlay] forState:UIControlStateNormal];
    [self.playButton setBackgroundImage:[self imageRecordPause] forState:UIControlStateSelected];
    self.playButtonLabel.text = @"开始";
    self.stopButtonLabel.text = @"结束";
    // 选中状态：pause
    self.playButton.selected = NO;
    [self.stopButton setBackgroundImage:[self imageRecordStop] forState:UIControlStateNormal];
    return YES;
}

- (BOOL)refreshStateRecord {
    self.playButtonLabel.text = @"正在录音";
    self.playButton.selected = YES;
    [self startTimer];
    return YES;
}

- (BOOL)refreshStatePause {
    self.playButtonLabel.text = @"暂停中";
    self.playButton.selected = NO;
    [self stopTimer];
    return YES;
}

- (BOOL)refreshStateStop {
    [self stopTimer];
    [self refreshStateInitial];
    return YES;
}

- (void)startTimer {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.volumeImageView.image = [self imageRecord:1];
}

- (void)detectionVoice {
    // 获取音量的平均值  [recorder averagePowerForChannel:0];
    // 音量的最大值  [recorder peakPowerForChannel:0];
    // 根据Apple文档，AVAudioRecorder的averagePowerForChannel和peakPowerForChannel方法返回的是分贝数据，数值在-160 - 0之间（可能会返回大于0的值如果超出了极限）
    // http://code4app.com/requirement/52a52718cb7e843d688b59ad
    // http://stackoverflow.com/questions/9247255/am-i-doing-the-right-thing-to-convert-decibel-from-120-0-to-0-120/16192481#16192481
    // double pow(double x, double y); x的y次方
    [self.recorder updateMeters];
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    NSLog(@"--- %lf", lowPassResults);
    if (0<lowPassResults<=0.06) {
          [self.volumeImageView setImage:[self imageRecord:1]];
    } else if (0.06<lowPassResults<=0.13) {
      [self.volumeImageView setImage:[self imageRecord:2]];
    } else if (0.13<lowPassResults<=0.20) {
      [self.volumeImageView setImage:[self imageRecord:3]];
    } else if (0.20<lowPassResults<=0.27) {
      [self.volumeImageView setImage:[self imageRecord:4]];
    } else if (0.27<lowPassResults<=0.34) {
      [self.volumeImageView setImage:[self imageRecord:5]];
    } else if (0.34<lowPassResults<=0.41) {
      [self.volumeImageView setImage:[self imageRecord:6]];
    } else if (0.41<lowPassResults<=0.48) {
      [self.volumeImageView setImage:[self imageRecord:7]];
    } else if (0.48<lowPassResults<=0.55) {
      [self.volumeImageView setImage:[self imageRecord:8]];
    } else if (0.55<lowPassResults<=0.62) {
      [self.volumeImageView setImage:[self imageRecord:9]];
    } else if (0.62<lowPassResults<=0.69) {
      [self.volumeImageView setImage:[self imageRecord:10]];
    } else if (0.69<lowPassResults<=0.76) {
      [self.volumeImageView setImage:[self imageRecord:11]];
    } else if (0.76<lowPassResults<=0.83) {
      [self.volumeImageView setImage:[self imageRecord:12]];
    } else if (0.83<lowPassResults<=0.9) {
      [self.volumeImageView setImage:[self imageRecord:13]];
    } else {
      [self.volumeImageView setImage:[self imageRecord:14]];
    }
}

// MARK: Get resource
- (NSBundle *)currentBundle {
    return [NSBundle bundleForClass:self.class];
}

- (NSBundle *)imageBundle {
    NSString *imageBundlePath = [[self currentBundle] pathForResource:@"recorderImages" ofType:@"bundle"];
    return [NSBundle bundleWithPath:imageBundlePath];
}

- (UIImage *)imageClose {
    return [UIImage imageNamed:@"close" inBundle:[self imageBundle] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageRecord:(int)index {
    NSString *imgName = [NSString stringWithFormat:@"record_animate_%02d", index];
    return [UIImage imageNamed:imgName inBundle:[self imageBundle] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageRecordPlay {
    return [UIImage imageNamed:@"play" inBundle:[self imageBundle] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageRecordPause {
    return [UIImage imageNamed:@"pause" inBundle:[self imageBundle] compatibleWithTraitCollection:nil];
}

- (UIImage *)imageRecordStop {
    return [UIImage imageNamed:@"stop" inBundle:[self imageBundle] compatibleWithTraitCollection:nil];
}

@end
