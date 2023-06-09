//
//  CharacterCellViewModel.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 4/30/23.
//

import Foundation

class CharacterCellViewModel {
    let title: String
    let description: String?
    let imageURLString: String?
    
    init(character: Character) {
        self.title = character.title
        self.description = character.description
        self.imageURLString = character.icon
    }
}
