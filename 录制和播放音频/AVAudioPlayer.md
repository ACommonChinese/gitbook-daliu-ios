# AVAudioPlayer  

AVAudioPlayer构建于CoreAudio中的C-based Audio Queue Services的最顶层，除非需要从网络流中播放音频、需要访问原始样本或者需要非常低的时延，否则AVAudioPlayer都能胜任。  

使用AVAudioPlayer可以播放基于内存NSData的音频，或基于本地文件的NSURL。  

```objective-c
// NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
// NSURL *fileURL = [NSURL fileURLWithPath:filePath];
NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"rock" withExtension:@"mp3"];
// 必须对player对象强引用
self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
if (self.player) {
    // Calling this method preloads buffers and acquires the audio hardware needed for playback, which minimizes the lag between calling the play method and the start of sound output.
    Calling the stop method, or allowing a sound to finish playing, undoes this setup.
    [self.player prepareToPlay];
}
```

调用prepareToPlay会取到需要的音频硬件并预加载Audio Queue缓冲区。调用prepareToPlay这个动作是可选的，当调用play方法时会隐性激活，不过在创建时准备播放器可以降低调用play方法和听到声音输出之间的延时。  

### 对播放进行控制  

- `[self.player play]`: play方法播放指定的音频文件    
- `[self.player pause]`: pause方法暂停播放行为，下次调用play方法时会从暂停的地方开始播放   
- `[self.player stop]`: 停止播放行为，注：下次调用play方法时会从暂停的地方开始播放，而不是从头开始播放，调用此方法和调用pause方法的区别在底层处理上，调用stop方法会撤消调用prepareToPlay时所做的设置，而调用pause方法不会。    
- `self.player.volume = [0 ~ 1]` : 最小值0.0表示静音，最大值1.0表示最大音量  
- `self.player.pan = [-1.0 ~ 1.0]`: By setting this property you can position a sound in the stereo field. A value of –1.0 is full left, 0.0 is center, and 1.0 is full right. 允许使用立体声播放声音，-1.0表示极左，1.0表示极右，0.0表示居中  
- `self.player.rate = [0.5 ~ 2.0]` 播放速率，范围从0.5(半速)到2.0(2倍速)  
- `self.player.numberOfLoops`: 循环次数，-1表示无限循环，正整数N表示循环播放N次  

注：在设置rate之前需要设置player.enableRate = YES 

enableRate:  
To enable adjustable playback rate for an audio player, set this property to YES after you initialize   the player and before you call the prepareToPlay instance method for the player.    




