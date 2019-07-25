# Enum列举

摘自[这里](https://swifter.tips/enum-enumerate/)

```Swift
//
//  main.swift
//  列举enum
//
//  Created by liuweizhen on 2019/7/25.
//  Copyright © 2019 liuxing8807@126.com. All rights reserved.
//

import Foundation

protocol EnumAllValuesProtocol {
    static var allValues: [Self] {
        get
    }
}

enum Suit : String, EnumAllValuesProtocol {
    case Spades = "黑桃"
    case Hearts = "红桃"
    case Clubs = "梅花"
    case Diamonds = "方块"
    
    static var allValues: [Suit] {
        return [.Spades, .Hearts, .Clubs, .Diamonds]
    }
}

enum Rank : Int, CustomStringConvertible, EnumAllValuesProtocol {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
    var description: String {
        switch self {
        case .Ace:
            return "A"
        case .Jack:
            return "J"
        case .Queen:
            return "Q"
        case .King:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
    
    static var allValues: [Rank] {
        return [.Ace, .Two, .Three,
                .Four, .Five, .Six,
                .Seven, .Eight, .Nine,
                .Ten, .Jack, .Queen, .King]
    }
}

for suit in Suit.allValues {
    for rank in Rank.allValues {
        print("\(suit.rawValue)\(rank)")
    }
}
```