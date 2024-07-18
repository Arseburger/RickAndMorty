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
    @IBOutlet private weak var tableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var service = CharacterService()
    private var characters: [Character] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearence()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Rick & Morty Characters"
        navigationItem.backButtonTitle = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        service.loadCharacters { [weak self] chars in
            self?.characters.append(contentsOf: chars)
            self?.tableView.reloadData()
        }
    }
    
    private func setupAppearence() {
        view.backgroundColor = .black
        activityIndicator.hidesWhenStopped = true
    }

}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView() {
        
        tableView.register(CharacterCell.nib, forCellReuseIdentifier: CharacterCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.tintColor = .clear
        
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        96.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        
        let char = characters[indexPath.row]
        cell.setCharacter(char)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let char = characters[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.setCharacter(char)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastRow = characters.count - 1
        
        if indexPath.row == lastRow {
            activityIndicator.startAnimating()
            tableViewBottomConstraint.constant = 32
            var newRows: [IndexPath] = []
            for row in lastRow ..< lastRow + 20 {
                newRows.append(IndexPath(row: row, section: 0))
            }
                
            service.loadCharacters { [weak self] chars in
                self?.characters.append(contentsOf: chars)
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
                self?.tableViewBottomConstraint.constant = 8
            }
        }
    }
    
}
