# Pod安装

参考：
镜像参考：[ruby-china](https://gems.ruby-china.com)

Pod是iOS平台的一个包管理器，package manager，使用

### 更换源
gem是ruby库的一个包管理器，下载更新pod可通过gem操作  
更换gem source为rubychina:  
gem sources —remove [https://rubygems.org/](https://rubygems.org/)  // 移除掉原有的源  
gem sources -a gem sources --add [https://gems.ruby-china.com/](https://gems.ruby-china.com/)
gem sources -l \# 验证是否成功  
源: ruby china官网地址：[https://gems.ruby-china.com/](https://gems.ruby-china.com/)

### 更新gem
upgrade to the latest RubyGems:  
gem update —system  
或：sudo gem update —system

OS X 10.11 以前安装命令为：  
sudo gem install cocoapods \# 安装cocoapods

Mac系统为OS X EL Capitan安装命令为：  
sudo gem install -n /usr/local/bin cocoapods  \# 安装最新版本  
sudo gem install -n /usr/local/bin cocoapods -v 1.0.0 \# 安装指定版本  
sudo gem install -n /usr/local/bin cocoapods --pre \# 安装最新的release beta版本

### 查看pod版本：  
`pod --version`

### Cocospod 安装

由于项目需要，同事间尽量使用统一版本的pod, 否则可能带来一些问题，比如Podfile.lock文件在最后一行就会标注使用的版本号：
```
COCOAPODS: 1.8.4
```
如果每个人使用的pod版本不一致，而Podfile.lock文件又提交到了git仓库中，不同的伙伴install可能产生文件不一致而需要重新install等问题   

查看当前版本：`pod --version`
检查当前安装版本列表: 
```
% gem list --local | grep cocoapods
cocoapods (1.8.4)
cocoapods-core (1.9.0.beta.2, 1.8.4)
cocoapods-deintegrate (1.0.4)
cocoapods-downloader (1.3.0)
cocoapods-plugins (1.0.0)
cocoapods-search (1.0.0)
cocoapods-stats (1.1.0)
cocoapods-trunk (1.4.1)
cocoapods-try (1.1.0)
```

```
# 安装版本1.6.1
sudo gem install cocoapods -v 1.6.1
```

### 卸载CocoaPods  
```
sudo gem uninstall cocoapods # 卸载cocoapods
sudo gem uninstall cocoapods 1.5.3 # 卸载指定版本1.5.3
```

### 索引库

打开cocoapods本地索引库：`open ~/.cocoapods/repos` 

更新Podspec索引文件:
pod setup
pod setup将所有第三方的Podspec索引文件更新到本地的~/.cocoapods/repos目录下
所有的第三方开源库的Podspec文件都托管在https://github.com/CocoaPods/Specs
我们需要把这个Podspec文件保存到本地，这样才能让我们使用命令pod search 开源库搜索一个开源库，怎样才能把github上的Podspec文件保存本地呢？那就是 pod setup
如果执行 pod setup，并且命令执行成功，说明把github上的Podsepc文件更新到本地，那么会创建~/.cocoapods/repos目录，并且repos目录里有一个master目录，这个master目录保存的就是github上所有第三方开源库的Podspec索引文件

