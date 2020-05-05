//
//  DLEnum.swift
//  network
//
//  Created by liuweizhen on 2020/5/5.
//  Copyright © 2020 liuxing8807@126.com. All rights reserved.
//

import UIKit

enum DLNetworkEnum: String {
    case Thread = "Thread"
    case Operation = "Operation"
    case Semaphore = "Semaphore"
    case DispathGroup = "DispathGroup"
    
    static var all: [DLNetworkEnum] {
        return [
            .Thread,
            .Operation,
            .Semaphore,
            .DispathGroup
        ]
    }
}
