# ARKit

ARKit是Apple为增强现实做的一个库, 参考链接: [Here](https://developer.apple.com/cn/documentation/)
> 结合运用 iOS 设备摄像头和运动功能，在您的 app 或游戏中提供增强现实体验。
> 通过设备摄像头为实时视图增添 2D 或 3D 元素，让这些元素逼真得仿佛真实存在，这就是“增强现实 (AR)”所指的用户体验。

现在最新版为ARKit3

一些概念: 

- 摄像头源: 
  - 后置摄像头源:   `class ARWorldTrackingConfiguration : ARConfiguration`
  - 前置摄像头源:  `class ARFaceTrackingConfiguration : ARConfiguration`

6DoF: Six degrees of freedom tracking, 六自由度追踪, the three rotation axes (roll, pitch, and yaw), and three translation axes (movement in x, y, and z).
随着SLAM (simultaneous localization and mapping)技术的普遍应用，6DoF追踪与SLAM相结合，沉浸式的AR体验时代终于来临了。

![](images/1.png)

前置摄像头源和后置摄像头源都被称为"Configuration", 只是前置摄像头源被称为`ARWorldTrackingConfiguration`, 而后置摄像头被称为`ARFaceTrackingConfiguration`

