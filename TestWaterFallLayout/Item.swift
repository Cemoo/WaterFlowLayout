//
//  Item.swift
//  TestWaterFallLayout
//
//  Created by Erencan Evren on 23.07.2018.
//  Copyright © 2018 Cemal BAYRI. All rights reserved.
//

import Foundation

struct MyData: Codable {
    var items: [Item]?
}

struct Item: Codable {
    var thumb_w: String?
    var thumb_h: String?
    var thumbUrl: String?
}


