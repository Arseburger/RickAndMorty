//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

struct Character: Decodable, Hashable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: String
    
    struct Location: Decodable, Hashable {
        let name: String
    }
    var location: Location
    
    var image: String
    var episode: [String]
    
    static let Rick = Character.init(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        gender: "Male",
        location: Location(
            name: "Citadel of Ricks"
        ),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [1...51].map {
            "https://rickandmortyapi.com/api/episode/\($0)"
        }
    )

    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}

    enum Status: String, Decodable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "Unknown"
        
        init?(rawValue: String) {
            switch rawValue {
                case "Alive": self = .alive
                case "Dead": self = .dead
                case "Unknown": self = .unknown
                default: self = .unknown
            }
        }
    }
