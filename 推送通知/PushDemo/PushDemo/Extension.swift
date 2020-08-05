//
//  Extension.swift
//  PushDemo
//
//  Created by 刘威振 on 2020/8/4.
//  Copyright © 2020 大刘. All rights reserved.
//

import Foundation

extension Data {
    //https://stackoverflow.com/questions/47386207/getting-remote-notification-device-token-in-swift-4
    //https://nshipster.com/apns-device-tokens/
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
