//
//  AppDelegate.swift
//  PushDemo
//
//  Created by 刘威振 on 2020/8/4.
//  Copyright © 2020 大刘. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationForPush(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

//https://stackoverflow.com/questions/39494834/fail-to-register-for-remote-notifications
//Error Domain=NSCocoaErrorDomain Code=3000 "no valid 'aps-environment' entitlement string found for application" UserInfo={NSLocalizedDescription=no valid 'aps-environment' entitlement string found for application}, no valid 'aps-environment' entitlement string found for application

