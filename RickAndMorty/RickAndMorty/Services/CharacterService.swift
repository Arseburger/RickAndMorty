//
//  CharacterService.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import Foundation

final class CharacterService {
    
    private let client = ApiClient()
    
    private var next: String?
    
    func loadCharacters(onComplete: @escaping ([Character]) -> Void) {
        
        let completion: (Result<RequestResult<[Character]>, Error>) -> Void = { result in
            switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        onComplete(result.results ?? [])
                    }
                    self.next = result.info?.next
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            if let next = self?.next {
                self?.client.loadRequest(url: next, completion: completion)
            } else {
                self?.client.loadRequest(method: .character, completion: completion)
            }
        }
    }
    
}
