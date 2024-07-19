import Foundation

struct RequestResult<T: Decodable>: Decodable {
    
    let results: T?
    let info: Info?
    
    struct Info: Decodable {
        var count: Int
        var pages: Int
        var next: String?
        var prev: String?
    }
}
