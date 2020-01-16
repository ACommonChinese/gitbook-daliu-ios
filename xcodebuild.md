# xcodebuild

### xcode build



```shell
which a xcodebuild # /usr/bin/xcodebuild
```

我们可以通过在浏览器键入：`x-man-page://xcodebuild`来查看xcodebuild的man page说明。

默认情况下，xcodebuild会把编译的输出放入`Location Preferences`，即Xcode > Preferences > Locations所指定的目录下。

一些xcodebuild的基本命令：
- 查看xcodebuild简洁用法 `xcodebuild -usage`
- 查看已安装的SDK `xcodebuild -showsdks`
```shell
$ xcodebuild -showsdks

iOS SDKs:
        iOS 12.2                        -sdk iphoneos12.2

iOS Simulator SDKs:
        Simulator - iOS 12.2            -sdk iphonesimulator12.2

macOS SDKs:
        macOS 10.14                     -sdk macosx10.14

tvOS SDKs:
        tvOS 12.2                       -sdk appletvos12.2

tvOS Simulator SDKs:
        Simulator - tvOS 12.2           -sdk appletvsimulator12.2

watchOS SDKs:
        watchOS 5.2                     -sdk watchos5.2

watchOS Simulator SDKs:
        Simulator - watchOS 5.2         -sdk watchsimulator5.2
```
- 查看安装的版本号 `xcodebuild -version`
- 查看项目中的Targets、Congigurations和Schemes，以上面Demo为例：
```shell
xcodebuild
-list
[[-project <projectname>]|[-workspace <workspacename>]] 

$ xcodebuild -list
Information about project "Demo":
    Targets:
        Demo

    Build Configurations:
        Debug
        QA
        Release

    If no build configuration is specified and -scheme is not passed then "Release" is used.

    Schemes:
        Demo
```

- Archive打包
```shell
xcodebuild
archive -archivePath <archivePath>
-project <projectName>
-scheme <schemeName> #从-list命令中获取
-configuration < Debug|Release...>
-sdk <sdkName> #sdkName可从showsdks命令中获取

以上面Demo示例，配置好TARGETS > General > Singing(QA)下面的Provisioning Profile后就可以打包了：
xcodebuild archive -archivePath ./ -project Demo.xcodeproj -scheme Demo -configuration QA
这样就在当前目录下生成了Demo.xcarchive文件包
```

也可以用Xcode手动操作：
![](./images/xcodebuild_5.png)
打包完成后，通过Window > Organizer找到打好的包，并Show in Finder, 可以看到，Xcode会生一个名字形如`Demo 2019-7-15, 4.33 PM.xcarchive`的包，即Demo [时间戮].xcarchive, 那我们这样打的包是哪个环境的呢？这个可以通过Edit Scheme…中查看：
![](./images/xcodebuild_6.png)
默认是Release,  注：如果要打哪个环境下面的包，就要配置好哪个环境下面的证书及配置文件Provisioning Profile

可以看到通过手动Xcode打的包(Archive)的文件目录形如：`/Users/daliu/Library/Developer/Xcode/Archives/`, 这个路径正是Xcode > Preferences > Locations > Archives 指定的路径
![](./images/xcodebuild_7.png)

通过命令或Xcode手动打包后生成的.xcarchive文件，可以转为.ipa包，以上面Demo为例：
把.xcarchive转.ipa包的核心叫`exportOptionsPlist`选项，这是一个plist格式的文件，需要在这个plist文件中告诉打包脚本`provisioningProfiles`等信息。如下新建一个名叫Demo.plist的文件(名字随意)

我这里以provisioning profile为Wildcard示例：

![](./images/xcodebuild_8.png)

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>development</string>
	<key>provisioningProfiles</key>
	<dict>
		<key>com.liuweizhen.Demo</key>
		<string>Wildcard</string>
	</dict>
	<key>signingStyle</key>
	<string>manual</string>
	<key>compileBitcode</key>
	<string>false</string>
	<key>teamID</key>
	<string>E97K6G9K4T</string>
</dict>
</plist>
```

有了这个plist文件，就可以调用命令生成.ipa了：

```Shell
xcodebuild -exportArchive -archivePath "Demo.xcarchive" -exportPath "./" -exportOptionsPlist "Demo.plist"
```

![](./images/xcodebuild_9.png)

这样就可以把ipa包通过Xcode > window > Devices and Simulators > click "+" 安装在手机上跑起来
![](./images/xcodebuild_10.png)

###打包framework

假设我们写了一个叫`BMAutolayout`的framework，使用脚本打包，由于framework分CPU架构，模拟器和真机不一样，需要合包，可以使用脚本完成，打包framework不需要证书，pofile配置文件，下面我们打Release包，示例：

universal-framework.sh

```Shell
#!/bin/sh

PROJECT_NAME=BMAutoLayout
TARGET=BMAutoLayout
CONFIGURATION=Release
BUILD_DIR=build

UNIVERSAL_OUTPUTFOLDER=${BUILD_DIR}/${CONFIGURATION}-universal

echo ${UNIVERSAL_OUTPUTFOLDER} # build/Release-universal

make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Step 1. Build Device and Simulator versions
xcodebuild -target "${TARGET}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphoneos BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build BITCODE_GENERATION_MODE=bitcode
xcodebuild -target "${TARGET}" ONLY_ACTIVE_ARCH=NO -configuration ${CONFIGURATION} -sdk iphonesimulator BUILD_DIR="${BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework"* "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Create universal binary file using lipo and place the combined executable in the copied framework directory
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}"
```

![](./images/xcodebuild_11.png)

### 打包项目并上传

推荐使用[fastlane](https://docs.fastlane.tools/getting-started/ios/setup/)

