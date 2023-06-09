//
//  CharactersViewController.swift
//  Simpsons Viewer
//
//  Created by Joshua Cleetus on 4/30/23.
//

import UIKit

class CharactersViewController: UIViewController {

    private let viewModel: CharactersViewModel
    let characterCellId = "CharacterCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: characterCellId)
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        return searchController
    }()
    
    private var filteredCharacters: [Character] {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            return viewModel.characters.filter { $0.title.localizedCaseInsensitiveContains(searchText) || $0.description?.localizedCaseInsensitiveContains(searchText) == true }
        }
        return viewModel.characters
    }
    
    init(viewModel: CharactersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Characters"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        viewModel.onCharactersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.onError = { error in
            print("Error fetching the characters: \(error)")
        }
        viewModel.fetchCharacters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .red
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: characterCellId, for: indexPath) as? CharacterCell else {
            fatalError("Unable to dequeue CharacterCell")
        }
        let character = filteredCharacters[indexPath.row]
        let cellViewModel = CharacterCellViewModel(character: character)
        cell.configure(with: cellViewModel)
        return cell
    }
}

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = filteredCharacters[indexPath.row]
        let detailViewModel = CharacterDetailViewModel(character: character)
        
        let detailViewController = CharacterDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension CharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.main.async {
            self.viewModel.searchText = searchController.searchBar.text ?? ""
        }
    }
}
