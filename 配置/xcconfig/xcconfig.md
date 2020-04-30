# xcconfig

### xcconfig是什么东西 

.xcconfig文件是通过文本方式指定build settings的一种形式  

> A Configuration Settings File (a file with a .xcconfig file extension), also known as a build configuration file or xcconfig file, is a plain text file that defines and overrides the build settings for a particular build configuration of a project or target. 

### 能用它做些什么  

比如，我们的app有debug, release, uat 等环境， 对应不同的server的地址， 可以通过不同的xcconfig配置来解决，打什么环境下的包就自动使用此环境下的地址， 而不用if-else判断  

### 示例：  

先建几个xcconfig文件： `File > new > Configuration Settings File`, 比如：  

![](images/2.png)  

在这四个.xcconfig文件中分别写入：  

```
BASE_URL = "http://www.common.com"   // 在common.xcconfig中写入
BASE_URL = "http://www.debug.com"    // 在debug.xcconfig中写入
BASE_URL = "http://www.release.com"  // 在release.xcconfig中写入
BASE_URL = "http://www.release.com"  // 在uat.xcconfig中写入
```

然后在Info中指定Project或Target的config:  

![](images/3.png)