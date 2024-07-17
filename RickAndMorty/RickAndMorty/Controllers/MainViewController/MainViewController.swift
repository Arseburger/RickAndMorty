//
//  MainViewController.swift
//  RickAndMorty
//
//  Created by Александр Королёв on 17.07.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private enum CharacterCell {
        static let identifier = "characterCell"
        static let nib = UINib(nibName: "CharacterTableViewCell", bundle: .main)
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Rick & Morty Characters"
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView() {
        
        tableView.register(CharacterCell.nib, forCellReuseIdentifier: CharacterCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.tintColor = .clear
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        96.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setCharacter(.Rick)
        
        return cell
    }
    
    
}
