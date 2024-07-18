import UIKit

final class MainViewController: UIViewController {
    
    private enum CharacterCell {
        static let identifier = "characterCell"
        static let nib = UINib(nibName: "CharacterTableViewCell", bundle: .main)
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private typealias DataSource = UITableViewDiffableDataSource<SingleSection, Character>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SingleSection, Character>
    
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
    
    func configureTableView() {
        
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
        viewModel.discovered(indexPath: indexPath)
    }
    
}
