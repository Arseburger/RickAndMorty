//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {

    @IBOutlet private weak var characterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var speciesLabel: UILabel!
    @IBOutlet private weak var genderLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearence()
    }
    
    private func setupAppearence() {
        
        bottomView.layer.cornerRadius = 24
        bottomView.backgroundColor = .init(named: "Background")
        
        nameLabel.font = IBMPlexSans.getFont(weight: .medium, of: 18)
        statusLabel.font = IBMPlexSans.getFont(weight: .semiBold, of: 12)
        speciesLabel.font = IBMPlexSans.getFont(weight: .semiBold, of: 12)
        genderLabel.font = IBMPlexSans.getFont(weight: .regular, of: 12)
        
        [nameLabel, speciesLabel, genderLabel].forEach {
            $0?.textColor = .white
        }
        
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.layer.cornerRadius = 10
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    func setCharacter(_ char: Character) {
        nameLabel.text = char.name
        statusLabel.text = char.status.rawValue
        switch char.status {
        case .alive:
                statusLabel.textColor = .init(named: "Green")
        case .dead:
                statusLabel.textColor = .init(named: "Red")
        case .unknown:
            statusLabel.textColor = .init(named: "Grey")
        }
        
        speciesLabel.text = char.species
        genderLabel.text = char.gender
        
        characterImageView.image = char.image
    }
    
}
