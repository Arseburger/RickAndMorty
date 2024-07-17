//
//  DetailViewController.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var episodesLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    var character: Character = .empty
    
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
    }
    
    func configure() {
        
        navigationItem.title = character.name
        
        imageView.image = self.character.image
        
        statusLabel.text = self.character.status.rawValue
        switch self.character.status {
            case .alive:
                statusLabel.backgroundColor = .init(named: "Green")
            case .dead:
                statusLabel.backgroundColor = .init(named: "Red")
            case .unknown:
                statusLabel.backgroundColor = .init(named: "Grey")
        }
        
        speciesLabel.attributedText = makeAttributedLabelText("Species: ", from: self.character.species)
        genderLabel.attributedText = makeAttributedLabelText("Gender: ", from: self.character.gender)
        locationLabel.attributedText = makeAttributedLabelText("Last known location: ", from: self.character.location)
        
        episodesLabel.attributedText = makeAttributedLabelText("Episodes: ", from: self.character.episodes.map { String($0) }.joined(separator: ", "))
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
