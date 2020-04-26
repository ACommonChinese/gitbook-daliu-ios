# File

```swift
func getPersistensePath() -> String? {
    // documentDirectory 是指程序中对应的Documents路径
    // documentationDirectory 对应于程序中的Library/Documentation路径，这个路径是没有读写权限的，所以看不到文件生成
    // iOS开发是在沙盒中开发的，对一些部分的文件的读写进行了限制，只能在几个目录下读写文件：
    //（1）Documents：应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
    //（2）tmp：存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
    //（3）Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    let filePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent("myFile").absoluteString
    return filePath
}
```
