import Foundation

final class CharacterService {

    private typealias CharacterResult = Result<RequestResult<[Character]>, Error>
    private let queue = DispatchQueue(label: "com.rick_morty.CharacterService", qos: .userInitiated)
    
    private let client = ApiClient()
    
    private var isFirstLoaded = false
    private var next: String?
    private var currentCount: Int = .zero
    private(set) var isCompleted: Bool = false

    private lazy var deduplicator = Set<Int>()
    
    func loadCharacters(onComplete: @escaping ([Character]) -> Void) {
        guard !isCompleted else {
            onComplete([])
            return
        }

        if let next = next, isFirstLoaded {
            client.loadRequest(url: next) { [weak self] (result: CharacterResult) in
                guard let self = self else { return }
                self.processPage(result: result, onComplete: onComplete)
            }
        } else {
            client.loadRequest(method: .character, params: nil) { [weak self] (result: CharacterResult) in
                guard let self = self else { return }
                self.processPage(result: result, onComplete: onComplete)
            }
        }
    }
    
    private func processPage(
        result: CharacterResult,
        onComplete: @escaping ([Character]) -> Void
    ) {
        self.queue.async {
            self.isFirstLoaded = true
            switch result {
                case .success(let res):
                    if let info = res.info, let characters = res.results {
                        self.currentCount += characters.count
                        if self.currentCount == info.count {
                            self.next = nil
                            self.isCompleted = true
                        } else {
                            self.next = info.next
                        }
                        onComplete(characters.compactMap { self.deduplicator.insert($0.id).inserted ? $0 : nil })
                        return
                    }
                    onComplete([])
                case .failure:
                    onComplete([])
            }
        }
    }
}
