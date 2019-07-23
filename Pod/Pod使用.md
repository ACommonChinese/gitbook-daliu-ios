# Pod使用


1. 新建Podfile文件
cd /… …/JYCocoaPodsTest
touch Podfile # 或者调用：pod init

2. 编辑Podfile文件（假设项目名为JYCocoaPodsTest）
示例：1

```Ruby
platform :ios, '9.0'
inhibit_all_warnings!

xcodeproj 'JYCocoaPodsTest'
workspace 'JYCocoaPodsTest' #指定应该包含所有projects的Xcode workspace. 如果没有显示指定workspace并且在Podfile所在目录只有一个project，那么project的名称会被用作于workspace的名称

use_frameworks!

target 'JYCocoaPodsTest' do 
pod 'AFNetworking'
pod 'JYCarousel', '0.0.1'

end
```

示例 2

```Ruby
source 'ssh://git@gitlab.9ijx.com:9830/iOS/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
 
platform :ios, '7.0'
use_frameworks! # swift项目默认 use_frameworks! OC项目cocoapods 默认 #use_frameworks!
inhibit_all_warnings! # 屏蔽cocoapods库里面的所有警告 pod 'JYCarousel', :inhibit_warnings => true
workspace 'JYCocoaPodsTest'
target 'JYCocoaPodsTest' do
pod 'AFNetworking'
pod 'JYCarousel', '0.0.1'
pod 'WCJCache', :git => "http://gitlab.9ijx.com/iOS/WCJCache.git"
 
target :JYCocoaPodsTestUITests do
    inherit! :search_paths #明确指定继承于父层的所有pod，默认就是继承的
    pod 'YYText'
 
end
```

注意上例中添加了非官方的source, source用于指定specs的位置, 自定义添加自己的podspec。
公司内部使用cocoapods 官方source是隐式的需要的，一旦你指定了其他source 你就需要也把官方的指定上
```Ruby
source 'ssh://git@gitlab.9ijx.com:9830/iOS/Specs.git'
source 'https://github.com/CocoaPods/Specs.git' # 官方的
```
添加后的新source, 系统会在 ~/.cocoapods/repo目录下建立相关目录。

**target**

```Ruby
target 'xxxx' do
  // ......
end

指定特定Target的依赖库, 可以嵌套子Target的依赖库

比如：

target 'JYCocoaPodsTest' do
pod 'AFNetworking'
pod 'JYCarousel', '0.0.1'

target :JYCocoaPodsTestUITests do
    inherit! :search_paths
    pod 'YYText'
 
end

end
```

即Target JYCocoaPodsTestUITests使用了YYText

**source**

指定specs的位置,自定义添加自己的podspec。公司内部使用

```Ruby
cocoapods 官方source是隐式的需要的，一旦你指定了其他source 你就需要也把官方的指定上
source 'ssh://git@gitlab.9ijx.com:9830/iOS/Specs.git'
source 'https://github.com/CocoaPods/Specs.git' # 官方的
```

当我们使用pod install或者pod setup时，会自动在~/.cocoapods/repo目录下生成相关source文件夹。

**依赖库的基本写法**
```Ruby
pod 'JYCarousel', //不显式指定依赖库版本，表示每次都获取最新版本
pod 'JYCarousel', '0.01'//只使用0.0.1版本
pod 'JYCarousel', '>0.0.1' //使用高于0.0.1的版本
pod 'JYCarousel', '>=0.0.1' //使用大于或等于0.0.1的版本
pod 'JYCarousel', '<0.0.2' //使用小于0.0.2的版本
pod 'JYCarousel', '<=0.0.2' //使用小于或等于0.0.2的版本
pod 'JYCarousel', '~>0.0.1' //使用大于等于0.0.1但小于0.1的版本，相当于>=0.0.1&&<0.1
pod 'JYCarousel', '~>0.1' //使用大于等于0.1但小于1.0的版本
pod 'JYCarousel', '~>0' //高于0的版本，写这个限制和什么都不写是一个效果，都表示使用最新版本
```

**依赖库的自定义写法**
`pod 'JYCarousel', :path => '/Users/Dely/Desktop/JYCarousel'`

注意：如果引入一个pod没有指定版本号，则当执行pod install第一次安装时，Podfile.lock文件中就会记录当前版本，并写下版本号，下一次再执行pod install, 即使有新版本也不会更新，除非指定了版本号或调用pod update。

