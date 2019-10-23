//
//  LandMark.swift
//  JSONDecoderDemo
//
//  Created by liuxing8807@126.com on 2019/10/23.
//  Copyright © 2019 liuweizhen. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var coordinates: Coordinates
    var state: String
    var park: String
    var category: Category // 假设分类有限，可做枚举
    var isFavorite: Bool

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }
}
