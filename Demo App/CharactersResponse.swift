//
//  CharactersResponse.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 5/1/23.
//

import Foundation

// MARK: - CharactersResponse
struct CharactersResponse: Codable {
    let characters: [Character]

    enum CodingKeys: String, CodingKey {
        case characters = "RelatedTopics"
    }
}
