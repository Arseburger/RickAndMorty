//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

struct Character {
    var image: UIImage
    var name: String
    var status: Status
    enum Status: String {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "Unknown"
    }
    var species: String
    var gender: String
    
    var episodes: [Int]
    var location: String
    
    static let Rick = Character(image: .init(named: "Rick")!, name: "Rick Sanchez", status: .alive, species: "Human", gender: "Male", episodes: .init(1...51), location: "Citadel of Ricks")
    
    static let empty = Character(image: .init(systemName: "pencil")!, name: "1", status: .unknown, species: "2", gender: "3", episodes: [4, 5, 6], location: "7")
}
