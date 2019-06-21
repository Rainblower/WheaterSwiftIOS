//
//  File.swift
//  WheaterSwiftIOS
//
//  Created by WSR on 21/06/2019.
//  Copyright © 2019 WSR. All rights reserved.
//

import Foundation

struct OpenWeatherError: Decodable {
    let code: Int?
    let message: String?
}
