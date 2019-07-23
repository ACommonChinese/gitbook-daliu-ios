# Pod安装

更换gem source为rubychina:  
gem sources —remove [https://rubygems.org/](https://rubygems.org/) \# 移除掉原有的源  
gem sources -a gem sources --add [https://gems.ruby-china.com/](https://gems.ruby-china.com/) \#\(参考：[https://gems.ruby-china.com/](https://gems.ruby-china.com/)\)  
gem sources -l \# 验证是否成功  
源: ruby china官网地址：[https://gems.ruby-china.com/](https://gems.ruby-china.com/)

upgrade to the latest RubyGems:  
gem update —system  
或： sudo gem update —system

OS X 10.11 以前安装命令为：  
sudo gem install cocoapods \# 安装cocoapods

Mac系统为OS X EL Capitan安装命令为：  
sudo gem install -n /usr/local/bin cocoapods  \# 安装最新版本  
sudo gem install -n /usr/local/bin cocoapods -v 1.0.0 \# 安装指定版本  
sudo gem install -n /usr/local/bin cocoapods --pre \# 安装最新的release beta版本

卸载CocoaPods:  
sudo gem uninstall cocoapods

查看pod版本：  
pod —version

cocoapods本地路径： .cocoapods/repos/master

更新Podspec索引文件:
pod setup
pod setup将所有第三方的Podspec索引文件更新到本地的~/.cocoapods/repos目录下
所有的第三方开源库的Podspec文件都托管在https://github.com/CocoaPods/Specs
我们需要把这个Podspec文件保存到本地，这样才能让我们使用命令pod search 开源库搜索一个开源库，怎样才能把github上的Podspec文件保存本地呢？那就是 pod setup
如果执行 pod setup，并且命令执行成功，说明把github上的Podsepc文件更新到本地，那么会创建~/.cocoapods/repos目录，并且repos目录里有一个master目录，这个master目录保存的就是github上所有第三方开源库的Podspec索引文件