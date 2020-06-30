//
//  JKVideoPlayer.m
//  JKVideo
//
//  Created by liuweizhen on 2020/6/27.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

#import "JKVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface JKVideoPlayer()

@property (nonatomic, strong) AVPlayerItem *videoItem;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end


/**
* AVPlayerItem中有一个status属性, 可以使用KVO进行监听
* From Apple:
* typedef NS_ENUM(NSInteger, AVPlayerItemStatus) {
    AVPlayerItemStatusUnknown = 0,
    AVPlayerItemStatusReadyToPlay = 1,
    AVPlayerItemStatusFailed = 2
};

*  @discussion
    The value of this property is an AVPlayerItemStatus that indicates whether the receiver can be used for playback.
    When the value of this property is AVPlayerItemStatusFailed, the receiver can no longer be used for playback and
    a new instance needs to be created in its place. When this happens, clients can check the value of the error
    property to determine the nature of the failure. The value of this property will not be updated after the receiver
    is removed from an AVPlayer. This property is key value observable.
 *  @property (readonly) AVPlayerItemStatus status;
*
* loadedTimeRanges表示缓冲相关的时间
 @property loadedTimeRanges
 @abstract This property provides a collection of time ranges for which the player has the media data readily available. The ranges provided might be discontinuous.
 @discussion Returns an NSArray of NSValues containing CMTimeRanges.
 @property (readonly) NSArray<NSValue *> *loadedTimeRanges;
 *
*/

@implementation JKVideoPlayer

+ (instancetype)sharedInstance {
    static JKVideoPlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[JKVideoPlayer alloc] init];
    });
    return player;
}

- (void)playVideoWithUrl:(NSString *)videoUrl attachView:(UIView *)attachView {
    [self _stopPlay];
    
    NSURL *videoURL = [NSURL URLWithString:videoUrl];
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    
    _videoItem = [AVPlayerItem playerItemWithAsset:asset];
    //监听status: fail readytoPlay
    [_videoItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听缓冲进度
    [_videoItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handlePlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    _avPlayer = [AVPlayer playerWithPlayerItem:_videoItem];
    [_avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"播放进度: %lf(s)", CMTimeGetSeconds(time));
    }];
    
    //https://lanhuapp.com/web/#/item/project/board/detail?pid=ed37d2c9-a6a3-4cf5-81b1-8191985370ca&project_id=ed37d2c9-a6a3-4cf5-81b1-8191985370ca&type=sectionImageChange&image_id=2de13420-7633-43a8-a20c-e9ff6a4cc6ff&childImg=0
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    //_playerLayer.frame = attachView.bounds;
    _playerLayer.frame = CGRectMake(10, 100, 800, 800);
    _playerLayer.contentsScale = [UIScreen mainScreen].scale;
    _playerLayer.masksToBounds = YES;
    _playerLayer.needsDisplayOnBoundsChange = YES;
    attachView.backgroundColor = UIColor.redColor;
    attachView.layer.needsDisplayOnBoundsChange = YES;
    [attachView.layer addSublayer:self.playerLayer];
}

- (void)_handlePlayEnd {
    NSLog(@"Play end");
    
    //重新播放
    //CMTimeCompare(time, kCMTimeZero)
    [_avPlayer seekToTime:kCMTimeZero]; // CMTimeMake(0, 1) // OK
    [_avPlayer play];
}

- (void)_stopPlay {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_videoItem removeObserver:self forKeyPath:@"status"];
    [_videoItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [_playerLayer removeFromSuperlayer];
    _videoItem = nil;
    _avPlayer = nil;
}

#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    // Only handle observations for the PlayerItemContext
//    if (context != &PlayerItemContext) {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        return;
//    }
//
    if ([keyPath isEqualToString:@"status"]) {
        // NSInteger
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        // Switch over the status
        switch (status) {
            case AVPlayerItemStatusReadyToPlay: {
                CMTime duration = _videoItem.duration;
                Float64 videoDuration = CMTimeGetSeconds(duration);
                NSLog(@"总共时间: %lf", videoDuration);
                //总共时间: 60.095000

                int64_t value = _videoItem.duration.value;
                int32_t timescale = _videoItem.duration.timescale;
                NSLog(@"value: %lld -- timescale: %d", value, timescale);
                //value: 36057 -- timescale: 600
                //36057/600 == 60.095
                //36057帧, 每秒600帧, 耗时60.095秒

                NSLog(@"AVPlayerItemStatusReadyToPlay");
                [self.avPlayer play];
                break;
            }
            case AVPlayerItemStatusFailed: {
                //发生错误
                NSLog(@"AVPlayerItemStatusFailed");
                NSError *error = [_videoItem error];
                if (error) {
                    NSLog(@"%@", error);
                }
                break;
            }
            case AVPlayerItemStatusUnknown: {
                // Not ready
                NSLog(@"AVPlayerItemStatusUnknown");
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //注意:这是缓冲时间, 不同于播放时间
        //一般缓冲之间要比播放时间提前
        //缓冲结束后的时间和_videoItem.duration的时间是一致的
        NSLog(@"缓冲进度: %@", [change objectForKey:NSKeyValueChangeNewKey]);
        NSArray<NSValue *> *array = [change objectForKey:NSKeyValueChangeNewKey];
        if (array.count > 0) {
            NSValue *value = array[0];
            CMTimeRange timeRange;
            [value getValue:&timeRange];
            CMTime start = timeRange.start;
            CMTime duration = timeRange.duration;
            NSLog(@">>> (%lld, %d | %lld, %d)", start.value, start.timescale, duration.value, duration.timescale);
        }
        
        //Network is very bad
        //
        //    "CMTimeRange: {{0/1 = 0.000}, {300/600 = 0.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {600/600 = 1.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {775/600 = 1.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {900/600 = 1.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {1075/600 = 1.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {1200/600 = 2.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {1375/600 = 2.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {1500/600 = 2.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {1800/600 = 3.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {1975/600 = 3.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {2100/600 = 3.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {2275/600 = 3.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {2400/600 = 4.000}}"
        //...
        //...
        //    "CMTimeRange: {{0/1 = 0.000}, {6600/600 = 11.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {6775/600 = 11.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {6900/600 = 11.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7075/600 = 11.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7200/600 = 12.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7375/600 = 12.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7500/600 = 12.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7675/600 = 12.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7800/600 = 13.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {7975/600 = 13.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {8100/600 = 13.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {8275/600 = 13.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {8400/600 = 14.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {8575/600 = 14.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {8700/600 = 14.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {8875/600 = 14.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9000/600 = 15.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9175/600 = 15.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9300/600 = 15.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9475/600 = 15.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9600/600 = 16.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9775/600 = 16.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {9900/600 = 16.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10075/600 = 16.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10200/600 = 17.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10375/600 = 17.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10500/600 = 17.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10675/600 = 17.792}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10800/600 = 18.000}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {10975/600 = 18.292}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {11100/600 = 18.500}}"
        //    "CMTimeRange: {{0/1 = 0.000}, {11275/600 = 18.792}}"
    }
}

/**
 播放进度
 typdef struct {
    CMTimeValue value, // 第几帧, 即第几张图片
    CMTimeScale timescale; // 帧率, 即1s钟播放多少图片
    CMTimeFlags flags;
    CMTimeEpoch epoch;
 } CMTime;
 调整播放进度
 seekableTimeRanges
 An array of time ranges within which it is possible to seek.
 - seekToTime:completionHandler:
 Sets the current playback time to the specified time and executes the specified block when the seek operation completes or is interrupted.
 
 
 CMTimeMake(int64_t value, int32_t timescale)
 
 CMTimeMake(第几帧, 帧率), 帧率指一秒钟播放多少张图片
 比如: CMTimeMake(24, 12), 播放到了24帧, 一秒播放12帧, 则现在播放进度是2s
 CMTimeMake(60, 30)  2s
 */

@end
