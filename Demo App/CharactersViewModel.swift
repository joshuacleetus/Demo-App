//
//  CharactersViewModel.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 4/30/23.
//

import Foundation

class CharactersViewModel {
    private let api: CharactersAPI
    private var allCharacters: [Character] = []
    
    var characters: [Character] {
        didSet {
            onCharactersUpdated?()
        }
    }
    
    var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                characters = allCharacters
            } else {
                characters = allCharacters.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.description?.localizedCaseInsensitiveContains(searchText) == true }
            }
        }
    }
    
    var onCharactersUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(api: CharactersAPI) {
        self.api = api
        self.characters = []
    }
    
    func fetchCharacters() {
        api.fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.allCharacters = characters
                self?.characters = characters
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}
