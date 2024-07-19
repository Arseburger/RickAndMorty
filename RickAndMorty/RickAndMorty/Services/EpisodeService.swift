import Foundation
final class EpisodeService {
    
    typealias EpisodeResult = Result<Episode, Error>
    typealias EpisodesResult = Result<[Episode], Error>
    
    private let client = ApiClient()
    
    func loadEpisodes(params: String?, onComplete: @escaping ([Episode]) -> Void) {
        
        client.loadBaseRequest(method: .episode, params: params) { (result: EpisodesResult) in
            switch result {
                case .success(let res):
                    onComplete(res)
                case .failure:
                    onComplete([])
            }
        }
    }
    
    func loadEpisode(params: String?, onComplete: @escaping (Episode) -> Void) {
        
        client.loadBaseRequest(method: .episode, params: params) { (result: EpisodeResult) in
            switch result {
                case .success(let res):
                    onComplete(res)
                case .failure(_):
                    fatalError()
            }
        }
    }
    
}
