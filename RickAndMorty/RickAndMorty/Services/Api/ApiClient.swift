//
//  ApiClient.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import Foundation

final class ApiClient {
    private let baseURL = "https://rickandmortyapi.com/api"
    
    enum Methods: String {
        case character = "/character"
        case loaction = "/location"
        case episode = "/episode"
    }
    
    func loadRequest<T: Decodable>(
        method: Methods,
        params: String? = nil,
        completion: @escaping (Result<RequestResult<T>, Error>) -> Void
    ) {
        var url = baseURL + method.rawValue
        if let params = params {
            url += "/\(params)"
        }
        loadRequest(url: url, completion: completion)
    }
    
    func loadRequest<T: Decodable>(
        url: String,
        completion: @escaping (Result<RequestResult<T>, Error>) -> Void
    ) {
        guard let url = URL(string: url) else { return }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(RequestResult<T>.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}
