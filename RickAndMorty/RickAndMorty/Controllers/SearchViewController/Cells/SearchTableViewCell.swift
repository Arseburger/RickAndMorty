import UIKit

enum SearchItemType {
    case status
    case gender
    case none
}

class SearchTableViewCell: UITableViewCell{
    
    static var identifier: String {
        .init(describing: self)
    }
    
    private var item: FilterOptions = (nil, nil) {
        didSet {
            configure()
        }
    }
    
    var didSelectItem: (FilterOptions) -> Void = { _ in }
    
    private var items: [String] = []

    private var type = SearchItemType.none
    var selectedRow = -1 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var label: UILabel = {
        $0.backgroundColor = .clear
        $0.font = IBMPlexSans.getFont(weight: .medium, of: 15)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private lazy var collectionView: UICollectionView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(SearchItemCollectionViewCell.self, forCellWithReuseIdentifier: SearchItemCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: getLayout()))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAppearence()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(item: SearchItemType) {
        self.type = item
        configure()
    }
    
    func configure() {
        switch type {
            case .status:
                label.text = "Status"
                items = Status.allCases.map { $0.rawValue }
            case .gender:
                label.text = "Gender"
                items = Gender.allCases.map { $0.rawValue }
            default: break
        }
    }

    func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        return layout
    }
    
    func setupAppearence() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        [label, collectionView].forEach { bottomView.addSubview($0) }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            bottomView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            
            label.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            label.topAnchor.constraint(equalTo: bottomView.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -4),
            
            collectionView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 4),
            collectionView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -4),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),
            
        ])
        
    }
}

extension SearchTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
            case .status:
                return Status.allCases.count
            case .gender:
                return Gender.allCases.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.identifier, for: indexPath) as? SearchItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]

        cell.configure(with: item)
        cell.selectedRow = indexPath.row == selectedRow
        
        return cell
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let item = items[indexPath.item]

        let width = item.widthOfString(usingFont: IBMPlexSans.getFont(weight: .regular, of: 12))
        return .init(width: width + 24, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        var isSelected = false
        if indexPath.row == selectedRow {
            selectedRow = -1
        } else {
            selectedRow = indexPath.row
            isSelected = true
        }
        switch type {
            case .status:
                let value = Status.init(rawValue: items[indexPath.item])
                didSelectItem((isSelected ? value : nil, nil))
            case .gender:
                let value = Gender.init(rawValue: items[indexPath.item])
                didSelectItem((nil, isSelected ? value : nil))
            default: break
        }
    }
}
