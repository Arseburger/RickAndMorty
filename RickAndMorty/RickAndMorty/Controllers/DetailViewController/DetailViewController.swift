import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    var character: Character = .Rick
    private lazy var service = EpisodeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backButtonTitle = ""
        navigationItem.title = ""
        configure()
    }
    
    func setCharacter(_ char: Character) {
        self.character = char
    }

}

private extension DetailViewController {
    
    func setupAppearence() {
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 16
        statusLabel.layer.masksToBounds = true
        statusLabel.font = IBMPlexSans.getFont(weight: .semiBold, of: 16.0)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        
        [speciesLabel, genderLabel, episodesLabel, locationLabel].forEach {
            $0?.numberOfLines = 0
        }
    }
    
    func configure() {
        
        navigationItem.title = character.name
        
        imageView.loadImage(by: character.image)
        
        statusLabel.text = character.status
        switch Status(rawValue: character.status) {
            case .alive:
                statusLabel.backgroundColor = .init(named: "Green")
            case .dead:
                statusLabel.backgroundColor = .init(named: "Red")
            case .unknown:
                statusLabel.backgroundColor = .init(named: "Grey")
            default:
                break
        }
        
        speciesLabel.attributedText = makeAttributedLabelText("Species: ", from: character.species)
        genderLabel.attributedText = makeAttributedLabelText("Gender: ", from: character.gender.rawValue)
        
        locationLabel.attributedText = makeAttributedLabelText("Last known location: ", from: (character.location.name))
        
        let eps = character.episode.map { $0.stringAfterLast("/") }.joined(separator: ",")
        
        if character.episode.count > 1 {
            
            
            service.loadEpisodes(params: eps) { [weak self] res in
                
                let text = res.map {
                    $0.name
                }.joined(separator: ", ")
                DispatchQueue.main.async {
                    self?.episodesLabel.attributedText = self?.makeAttributedLabelText("Episodes: ", from: text)
                }
            }
            
        } else {
            service.loadEpisode(params: eps) { [weak self] ep in
                DispatchQueue.main.async {
                    self?.episodesLabel.attributedText = self?.makeAttributedLabelText("Episodes: ", from: ep.name)
                }
            }
        }
        
    }
                                                               
    
    func makeAttributedLabelText(_ prefix: String, from string: String) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(NSAttributedString(string: prefix, attributes: [
            .font : IBMPlexSans.getFont(weight: .semiBold, of: 16.0),
            .foregroundColor : UIColor.white
        ]))
        
        result.append(NSAttributedString(string: string, attributes: [
            .font : IBMPlexSans.getFont(weight: .regular, of: 16.0),
            .foregroundColor : UIColor.white
        ]))
        
        return result
    }
    
}
