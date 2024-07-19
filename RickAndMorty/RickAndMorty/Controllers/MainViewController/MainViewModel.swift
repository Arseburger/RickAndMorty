import Foundation

enum Sections: Hashable {
    case single
    case multiple
}

protocol MainViewModelListener: AnyObject {
    func apply(items: [Character])
}

protocol FilterDelegate {
    var currentGender: Gender? { get }
    var currentStatus: Status? { get }

    func resetFilter()
    func applyFilter(newGender: Gender?, newStatus: Status?)
}

final class MainViewModel: FilterDelegate {

    // MARK: Constants-
    private enum Constants {
        static let pageSize = 20
    }
        
    // MARK: FilterDelegate variables-
    private(set) var currentGender: Gender?
    private(set) var currentStatus: Status?

    // MARK: Variables-
    private lazy var service = CharacterService()
    weak var listener: MainViewModelListener?
    private var discover: IndexPath?
    private(set) var array: [Character] = []

    // MARK: Methods

    func touch() {
        guard !service.isCompleted else { return }
        loadNext()
    }

    func reached(indexPath: IndexPath) {
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

    // MARK: FilterDelegate methods

    func resetFilter() {
        applyFilter(newGender: nil, newStatus: nil)
    }

    func applyFilter(newGender: Gender?, newStatus: Status?) {
        currentGender = newGender
        currentStatus = newStatus

        service.gender = newGender
        service.status = newStatus
        array.removeAll()
        listener?.apply(items: [])
        touch()
    }
}
