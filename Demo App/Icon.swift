//
//  Icon.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 5/1/23.
//

import Foundation

// MARK: - Icon
struct Icon: Codable {
    let height, url, width: String

    enum CodingKeys: String, CodingKey {
        case height = "Height"
        case url = "URL"
        case width = "Width"
    }
}
