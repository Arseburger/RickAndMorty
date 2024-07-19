import Foundation

final class CharacterService {

    private typealias CharacterResult = Result<RequestResult<[Character]>, Error>
    
    private let client = ApiClient()
    private let queue = DispatchQueue(label: "com.rick_morty.CharacterService", qos: .userInitiated)
    
    private var next: String?
    private var currentCount: Int = .zero
    private var isFirstLoaded = false
    private var isLoading = false
    private(set) var isCompleted: Bool = false

    var gender: Gender? {
        didSet {
            reset()
        }
    }
    var status: Status? {
        didSet {
            reset()
        }
    }

    private lazy var deduplicator = Set<Int>()
    
    func loadCharacters(onComplete: @escaping ([Character]) -> Void) {
        guard !isCompleted else {
            onComplete([])
            return
        }

        guard !isLoading else { return }
        isLoading = true

        if let next = next, isFirstLoaded {
            client.loadRequest(url: next) { [weak self] (result: CharacterResult) in
                guard let self = self else { return }
                self.processPage(result: result, onComplete: onComplete)
            }
        } else {
            let params = getParams()
            client.loadRequest(method: .character, params: params) { [weak self] (result: CharacterResult) in
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
            self.isLoading = false
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

    private func reset() {
        next = nil
        currentCount = .zero
        deduplicator.removeAll()
        isCompleted = false
        isLoading = false
    }
    
    private func getParams() -> String? {
        var paramStr = [String]()
        if let gender = gender {
            paramStr.append("gender=\(gender.rawValue.lowercased())")
        }
        
        if let status = status {
            paramStr.append("status=\(status.rawValue.lowercased())")
        }
        
        if paramStr.isEmpty {
            return nil
        }
        
        return "?" + paramStr.joined(separator: "&")
    }
}
