//
//  CharactersAPI.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 4/30/23.
//

import Foundation

protocol CharactersAPI {
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void)
}

class URLSessionCharactersAPI: CharactersAPI {
    func fetchCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        let url = URL(string: Bundle.main.apiBaseURL)!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(CharactersResponse.self, from: data)
                completion(.success(response.characters))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

extension Bundle {
    var apiBaseURL: String {
        return object(forInfoDictionaryKey: "ServerURL") as? String ?? ""
    }
}
