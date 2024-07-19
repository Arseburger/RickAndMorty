import UIKit

final class MainViewController: UIViewController {
    
    private enum CharacterCell {
        static let identifier = "characterCell"
        static let nib = UINib(nibName: "CharacterTableViewCell", bundle: .main)
    }
    
    private typealias DataSource = UITableViewDiffableDataSource<Sections, Character>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, Character>
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filtersCollectionView: UICollectionView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var hasFilters: Bool {
        return viewModel.currentStatus == .none && viewModel.currentGender == .none
    }
    
    private var options: [String] {
        [viewModel.currentStatus?.rawValue, viewModel.currentGender?.rawValue].compactMap { $0 }
    }
    
    private lazy var fadeView: UIView = {
        $0.backgroundColor = .black.withAlphaComponent(0.2)
        $0.alpha = 0.0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var searchVC = SearchViewController()
    
    @IBAction private func filterButtonPressed(_ sender: Any) {
        openSearchVC()
    }
    
    private lazy var dataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
        guard let self = self else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        let char = self.viewModel.array[indexPath.row]
        cell.setCharacter(char)
        
        return cell
    }

    private lazy var viewModel = MainViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        configureTableView()
        configureCollectionView()
        _ = dataSource
        viewModel.listener = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.touch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupAppearence() {
        navigationItem.title = "Rick & Morty Characters"
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = .clear
        searchBar.placeholder = "Search"
        searchBar.isUserInteractionEnabled = false
        
        view.addSubview(fadeView)
        NSLayoutConstraint.activate([
            fadeView.topAnchor.constraint(equalTo: searchBar.topAnchor),
            fadeView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            fadeView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            fadeView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
        
        searchVC.setOptions((viewModel.currentStatus, viewModel.currentGender))
        searchVC.setActions (
            reset: { [weak self] in
                guard let self = self else { return }
                self.viewModel.resetFilter()
                self.filtersCollectionView.isHidden = true
                self.filterButton.setImage(.init(named: "Filters"), for: .normal)
            },
            apply: { [weak self] options in
                guard let self = self else { return }
                self.viewModel.applyFilter(newGender: options.gender, newStatus: options.status)
                self.filtersCollectionView.isHidden = [options.gender?.rawValue, options.status?.rawValue].compactMap { $0 }.count == 0
                self.filtersCollectionView.reloadData()
                self.filterButton.setImage(.init(named: "Filters")?.withTintColor(.init(named: "Filter")!), for: .normal)
                self.openSearchVC()
            },
            close: { [weak self] in
                guard let self = self else { return }
                self.openSearchVC()
            }
        )
        
        addChild(searchVC)
        view.addSubview(searchVC.view)
        searchVC.didMove(toParent: self)
        searchVC.view.frame = .init(origin: .init(x: .zero, y: view.frame.maxY + 400), size: .init(width: view.frame.width, height: 400))
        searchVC.view.isHidden = true
        
        
        
    }

    private func openSearchVC() {
        let endYPos = searchVC.view.isHidden ? view.frame.maxY - searchVC.view.frame.height : view.frame.maxY + searchVC.view.frame.height
        let saved = searchVC.view.isHidden
        searchVC.view.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.searchVC.view.frame.origin = .init(x: .zero, y: endYPos)
            self.fadeView.alpha = saved ? 1.0 : 0.0
        } completion: { _ in
            self.searchVC.view.isHidden = !saved
        }
    }
}

extension MainViewController: MainViewModelListener {

    func apply(items: [Character]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.single])
        snapshot.appendItems(items, toSection: .single)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MainViewController: UITableViewDelegate {
    
    private func configureTableView() {
        
        tableView.register(CharacterCell.nib, forCellReuseIdentifier: CharacterCell.identifier)
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.tintColor = .clear
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        96.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let char = viewModel.array[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.setCharacter(char)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.reached(indexPath: indexPath)
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    private func configureCollectionView() {
        filtersCollectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self

        filtersCollectionView.register(SearchItemCollectionViewCell.self, forCellWithReuseIdentifier: SearchItemCollectionViewCell.identifier)
        filtersCollectionView.reloadData()
        filtersCollectionView.showsHorizontalScrollIndicator = false
        filtersCollectionView.showsVerticalScrollIndicator = false
        filtersCollectionView.isHidden = hasFilters
    }
    
    func collectionView(_ collection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.identifier, for: indexPath) as? SearchItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item == options.count {
            cell.configure(with: "Reset filters")
        } else {
            cell.configure(with: options[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == options.count {
            searchVC.resetButtonPressed()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if options.isEmpty {
            return .zero
        }
        
        return options.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = indexPath.item == options.count ? "Reset filters" : options[indexPath.item]
        let width = item.widthOfString(usingFont: IBMPlexSans.getFont(weight: .regular, of: 12))
        return .init(width: width + 24, height: 36)
    }
}
