//
//  AppDelegate+Push.swift
//  PushDemo
//
//  Created by 刘威振 on 2020/8/4.
//  Copyright © 2020 大刘. All rights reserved.
//

import UIKit

extension AppDelegate: UNUserNotificationCenterDelegate {
    func applicationForPush(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
         // Only consider iOS10.0 or later here
         let center: UNUserNotificationCenter = UNUserNotificationCenter.current()
         center.delegate = self
         let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        //这会弹出一个提示框请求用户授予通知权限
        //"SwiftPushDemo"想给您发送通知
        //不允许    允许
        center.requestAuthorization(options: options) { (granted, error) in
            if (granted) {
                print("注册成功")
            } else {
                print("注册失败: ", error?.localizedDescription ?? "null")
            }
        }
        application.registerForRemoteNotifications() // Register to receive remote notifications via Apple Push Notification service.
        //如果`requestAuthorization`用户点击了不允许,registerForRemoteNotifications依然可能正常获取deviceToken, 但是:
        //If you want your app’s remote notifications to display alerts, play sounds, or perform other user-facing actions, you must request authorization to do so using the requestAuthorization(options:completionHandler:) method of UNUserNotificationCenter. If you do not request and receive authorization for your app's interactions, the system delivers all remote notifications to your app silently.
     }
    
    // MARK: - UNUserNotificationCenterDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // print("device token: ", deviceToken.base64EncodedString()) // server接收到后需要decode base 64
        // print(deviceToken.hexString)
        // https://nshipster.com/apns-device-tokens/
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("regist remote notification success, deviceToken: ", deviceTokenString)
        //regist remote notification success, deviceToken:  82c8fdbd48402a23a40710731ed435cd82149fc9761e0bab21874d5ffd01e27f
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("regist remote notification fail: ", error.localizedDescription)
        //未找到应用程序的“aps-environment”的授权字符串
        //no valid 'aps-environment' entitlement string found for application
    }
}
