import UIKit

struct Character: Decodable, Hashable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var gender: Gender
    
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
        gender: .male,
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

protocol MyEnum {
    associatedtype Item
    var item: Item? { get }
}

typealias FilterOptions = (status: Status?, gender: Gender?)
    
enum Status: String, Decodable, CaseIterable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "Unknown"
    
    init?(rawValue: String) {
        switch rawValue {
            case "Alive": self = .alive
            case "Dead": self = .dead
            default: self = .unknown
        }
    }
}

enum Gender: String, Decodable, CaseIterable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "Unknown"
    
    init?(rawValue: String) {
        switch rawValue {
            case "Female": self = .female
            case "Male": self = .male
            case "Genderless": self = .genderless
            default: self = .unknown
        }
    }
}
