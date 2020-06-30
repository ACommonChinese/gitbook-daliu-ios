//
//  JKPlayerView.m
//  JKVideo
//
//  Created by 刘威振 on 2020/6/30.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

#import "JKPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation JKPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

@end
