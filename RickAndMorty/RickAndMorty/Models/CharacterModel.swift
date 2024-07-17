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
    
    static let Rick = Character(image: .init(named: "Rick")!, name: "Rick Sanchez", status: .alive, species: "Human", gender: "Male")
}
