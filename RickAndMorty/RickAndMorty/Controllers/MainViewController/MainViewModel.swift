import Foundation

protocol MainViewModelListener: AnyObject {
    func apply(items: [Character])
}

enum SingleSection: Hashable {
    case single
}

final class MainViewModel {

    // MARK: Constants

    private enum Constants {
        static let pageSize = 20
    }

    weak var listener: MainViewModelListener?
    private lazy var service = CharacterService()
    private var discover: IndexPath?
    private(set) var array: [Character] = []

    func touch() {
        guard !service.isCompleted else { return }
        loadNext()
    }

    func discovered(indexPath: IndexPath) {
        self.discover = indexPath
        if
            !service.isCompleted,
            indexPath.row % Constants.pageSize >= Constants.pageSize - 1
        {
            loadNext()
        }
    }

    private func loadNext() {
        service.loadCharacters { [weak self] characters in
            DispatchQueue.main.async {
                guard let self = self, let listener = self.listener else { return }
                self.array.append(contentsOf: characters)
                listener.apply(items: self.array)
            }
        }
    }
}
