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

