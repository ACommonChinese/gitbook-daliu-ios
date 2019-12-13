# 录制和播放音频

### 理解音频会话AVAudioSession

AVAudioSession隶属AVFoundation框架，它是音频会话类。音频会话在应用程序和操作系统之间扮演着中间人的角色。它提供了一种简单实用的方法使OS得知应用程序应该如何与iOS音频环境进行交互。 【摘自AVFoundation开发秘籍】
无论是否使用音频功能，所有iOS应用都具有音频会话，默认音频会话有以下预配置：  
- 激活了音频播放，但是音频录制未激活
- 当用户切换响铃/静音开关到“静音”模式时，应用程序播放的所有音频都会消失
- 当设备显示解锁屏幕时，应用程序的音频处理静音状态
- 当应用程序播放音频时，所有后台播放的音频都会处于静音状态  

### 配置AVAudioSession

可以通过设置category和modes对AVAudioSession进行配置，比如设置Plackback分类后，应用程序允许将输出音频和背景声音进行混合。   
音频会话在应用程序的生命周期中是可以修改的，但通常只对其配置一次，一般会在应用程序启动时 application:didFinishLaunchingWithOptions: 进行配置  

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"Category Error: %@", [error localizedDescription]);
    }
    if (![session setActive:YES error:&error]) {
        NSLog(@"Activation Error: %@", [error localizedDescription]);
    }
    return YES;
}
```

AVAudioSession提供了与应用程序音频会话交互的接口，所以开发者需要取得指向该单例的指针。通过设置合适的分类，开发者可为音频的播放指定需要的音频会话，其中定制一些行为，最后告知该音频会话激活该配置。Category有如下配置：  

| 类别                                  | 当按“静音”或者锁屏是是否静音 | 是否引起不支持混音的App中断 | 是否支持录音和播放   |
| ------------------------------------- | ---------------------------- | --------------------------- | -------------------- |
| AVAudioSessionCategoryAmbient         | 是                           | 否                          | 只支持播放           |
| AVAudioSessionCategoryAudioProcessing | -                            | 都不支持                    |                      |
| AVAudioSessionCategoryMultiRoute      | 否                           | 是                          | 既可以录音也可以播放 |
| AVAudioSessionCategoryPlayAndRecord   | 否                           | 默认不引起                  | 既可以录音也可以播放 |
| AVAudioSessionCategoryPlayback        | 否                           | 默认引起                    | 只用于播放           |
| AVAudioSessionCategoryRecord          | 否                           | 是                          | 只用于录音           |
| AVAudioSessionCategorySoloAmbient     | 是                           | 是                          | 只用于播放           |

上面我们设置了 `[session setActive:YES error:&error]`， 因为AVAudioSession会影响其他App的表现，当自己App的Session被激活，其他App的就会被解除激活，如何要让自己的Session解除激活后恢复其他App Session的激活状态呢？此时可以用： `-(BOOL)setActive:(BOOL)active withOptions:(AVAudioSessionSetActiveOptions)options error:(NSError * _Nullable *)outError;` 这里的options传入`AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation` 即可， 也可以通过`otherAudioPlaying`变量来提前判断当前是否有其他App在播放音频。

option的各个参数可参见：  
https://www.jianshu.com/p/3e0a399380df/     
https://developer.apple.com/documentation/avfoundation/avaudiosession?language=objc