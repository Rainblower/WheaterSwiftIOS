//
//  Wheater.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 20/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import Foundation

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}
