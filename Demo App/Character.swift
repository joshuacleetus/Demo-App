//
//  RelatedTopic.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 5/1/23.
//

import Foundation

// MARK: - RelatedTopic
struct Character: Codable {
    let firstURL: String
    let imageIcon: Icon
    let result, text: String
    
    var title: String {
        return text.components(separatedBy: " - ").first ?? ""
    }
    
    var description: String? {
        return text.components(separatedBy: " - ").last
    }
    
    var icon: String {
        return "https://duckduckgo.com" + imageIcon.url
    }

    enum CodingKeys: String, CodingKey {
        case firstURL = "FirstURL"
        case imageIcon = "Icon"
        case result = "Result"
        case text = "Text"
    }
}
