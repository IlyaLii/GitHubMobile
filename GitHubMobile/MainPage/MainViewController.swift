//
//  MainViewController.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

enum SearchType: String, CaseIterable {
    case repositories = "repositories"
    case code = "code"
    case commits = "commits"
    case users = "users"
}

class MainViewController: BaseMainViewController {
    
    private var authService: AuthService!
    private var searchController: UISearchController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModels()
        setupUI()
    }
    
    @objc private func setupModels() {
        authService = AuthService.shared
        if userInfo == nil {
            authService.userInfo { (result) in
                switch result {
                case.success(let user):
                    self.userInfo = user
                case.failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.rawValue)
                    }
                }
            }
        }
        
        authService.reposInfo { (result) in
            switch result {
            case.success(var repos):
                repos.sort {$0.updated_at! > $1.updated_at!}
                self.repos = repos
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.rawValue)
                }
            }
        }
    }
    
    //MARK: -UI
    private func setupUI() {
        title = "Profile"
        searchController = UISearchController(searchResultsController: SearchViewController())
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = SearchType.allCases.map { $0.rawValue.capitalized }
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        navigationItem.searchController = searchController
        
        let button = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings(sender:)))
        navigationItem.leftBarButtonItem = button
        navigationItem.rightBarButtonItem = settings
    }
    
    @objc private func openSettings(sender: UIBarButtonItem!) {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}


extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let resultController = searchController.searchResultsController as? SearchViewController else { return }
        resultController.setActiviyView()
        let searchType = SearchType(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex].lowercased())
        guard let type = searchType else { return }
        if searchBar.text!.count <= 1 { return }
        guard let authService = authService else { return }
        authService.search(type: type, request: searchBar.text!, login: userInfo.login) { (repo, users, code) in
            switch type {
            case .code :
                resultController.result = (repo, users , code)
                resultController.type = type
            case .commits: break
            case .repositories:
                resultController.result = (repo, users , code)
                resultController.type = type
            case .users:
                resultController.result = (repo, users , code)
                resultController.type = type
            }
            DispatchQueue.main.async {
                resultController.removeActivityView()
                resultController.tableView.reloadData()
            }
        }
    }
}
