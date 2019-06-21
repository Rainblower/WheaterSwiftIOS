//
//  Sys.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 20/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import Foundation

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}


