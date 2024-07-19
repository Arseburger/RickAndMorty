import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        .init(describing: self)
    }
    
    private lazy var titleLabel: UILabel = {
        $0.textAlignment = .center
        $0.font = IBMPlexSans.getFont(weight: .regular, of: 12)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private lazy var checkmarkImage: UIImageView = {
        $0.image = .checkmark
        return $0
    }(UIImageView())

    var selectedRow: Bool = false {
        didSet {
            contentView.backgroundColor = selectedRow ? .white : .init(red: 30/255, green: 30/255, blue: 32/255, alpha: 1)
            titleLabel.textColor = selectedRow ? .black : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        
        contentView.backgroundColor = .init(red: 30/255, green: 30/255, blue: 32/255, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.init(named: "Background")?.cgColor
        contentView.layer.borderWidth = 2
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        titleLabel.text = text
    }
}
