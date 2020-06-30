//
//  ViewController.m
//  JKVideoDemo
//
//  Created by liuweizhen on 2020/6/27.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

#import "ViewController.h"
#import <JKVideo/JKVideo.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
//    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//    redView.backgroundColor = UIColor.redColor;
//    [self.view addSubview:redView];
}

- (IBAction)systemAVPlayerViewController:(id)sender {
}

- (IBAction)customPlayerForLocal:(id)sender {
    
}

- (IBAction)customPlayerForRemote:(id)sender {
    // 电影片断
    // http://testmp4.ywan3.com/tianqi/video/8bd9032559a74e0f83423b81d70f80f0.mp4
    
    // 天气预报
    NSString *url = @"http://testmp4.ywan3.com/tianqi/video/8bd9032559a74e0f83423b81d70f80f0.mp4";
    
    // 动画小视频片断
    // NSString *url = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    // NSString *url = @"https://haokan.baidu.com/v?vid=15976873890726338885&pd=bjh&fr=bjhauthor&type=video";
    [[JKVideoPlayer sharedInstance] playVideoWithUrl:url attachView:self.view];
}

@end
