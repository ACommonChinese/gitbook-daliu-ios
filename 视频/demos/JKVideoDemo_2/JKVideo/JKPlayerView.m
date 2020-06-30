//
//  JKPlayerView.m
//  JKVideo
//
//  Created by 刘威振 on 2020/6/30.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

#import "JKPlayerView.h"

@implementation JKPlayerView

- (AVPlayer *)player {
    return self.playerLayer.player;
}

- (void)setPlayer:(AVPlayer *)player {
    // 本质目的只有一个: 让AVPlayer的输入流和一个layer建立关联
    // 而这个layer在这里其实就是本视图的layer self.layer
    self.playerLayer.player = player;
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

// Override UIView method
// Noted: The value of a player layer’s inherited contents property is opaque and should not be used.
+ (Class)layerClass {
    // `AVPlayer`需要`AVPlayerLayer`承载其输出流
    // 因此重写 `layerClass` 以符合`AVPlayer`的要求
    // Apple: https://developer.apple.com/documentation/avfoundation/avplayerlayer?language=objc
    return [AVPlayerLayer class];
}

@end
