import UIKit

final class SearchViewController: UIViewController {
    
    typealias Action = () -> Void
    
    private lazy var titleLabel: UILabel = {
        $0.font = IBMPlexSans.getFont(weight: .semiBold, of: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Filters"
        return $0
    }(UILabel())
    
    private lazy var tableView: UITableView = {
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        $0.delegate = self
        $0.dataSource = self
        $0.allowsSelection = false
        $0.separatorStyle = .none
        return $0
    }(UITableView())
    
    private lazy var resetButton: UIButton = {
        $0.titleLabel?.font = IBMPlexSans.getFont(weight: .regular, of: 14)
        $0.setTitle("Reset", for: .normal)
        $0.setTitleColor(.init(named: "Filter"), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var closeButton: UIButton = {
        $0.setImage(.init(named: "Close")?.withTintColor(.white), for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var applyButton: UIButton = {
        $0.backgroundColor = .init(named: "Filter")
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(applyButtonPressed), for: .touchUpInside)
        $0.setTitle("Apply", for: .normal)
        $0.layer.cornerRadius = 16
        
        return $0
    }(UIButton())
    
    private lazy var stackView: UIStackView = {
        $0.distribution = .equalCentering
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.addArrangedSubview(closeButton)
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(resetButton)
        return $0
    }(UIStackView())
    
    var options: FilterOptions = (nil, nil)
    
    var close: Action = { }
    var apply: (FilterOptions) -> Void = { _ in  }
    var reset: Action = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
    }
    
    private func setupAppearence() {
        view.backgroundColor = .init(named: "Background")
        [stackView, tableView, applyButton].forEach {
            view.addSubview($0)
        }
        
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            
            applyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            applyButton.heightAnchor.constraint(equalToConstant: 42),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -24)
        ])
    }
    
    @objc
    func resetButtonPressed() {
        reset()
        options = (nil, nil)
        tableView.reloadData()
    }
    
    @objc
    private func closeButtonPressed() {
        close()
    }
    
    @objc
    private func applyButtonPressed() {
        apply(options)
    }
    
    func setActions(reset: @escaping Action, apply: @escaping (FilterOptions) -> Void, close: @escaping Action) {
        self.reset = reset
        self.apply = apply
        self.close = close
    }
    
    func setOptions(_  options: FilterOptions) {
        self.options = options
        tableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
            
        }
        
        if indexPath.item == 0 {
            cell.set(item: .status)
            if let status = options.status {
                cell.selectedRow = Status.allCases.firstIndex(of: status) ?? -1
            } else {
                cell.selectedRow = -1
            }
            cell.didSelectItem = { [weak self] options in
                self?.options = (options.status, self?.options.gender)
            }
        } else {
            cell.set(item: .gender)
            if let gender = options.gender {
                cell.selectedRow = Gender.allCases.firstIndex(of: gender) ?? -1
            } else {
                cell.selectedRow = -1
            }
            cell.didSelectItem = { [weak self] options in
                self?.options = (self?.options.status, options.gender)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
}
