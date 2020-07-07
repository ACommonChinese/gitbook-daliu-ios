//
//  JKPlayerView.h
//  JKVideo
//
//  Created by 刘威振 on 2020/6/30.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//  https://developer.apple.com/documentation/avfoundation/avplayerlayer?language=objc

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKPlayerView : UIView

- (AVPlayer *)player;
- (void)setPlayer:(AVPlayer *)player;

- (AVPlayerLayer *)playerLayer;

@end

NS_ASSUME_NONNULL_END
