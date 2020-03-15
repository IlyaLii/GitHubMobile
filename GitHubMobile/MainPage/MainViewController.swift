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

class MainViewController: UIViewController {
    
    private var authService: AuthService!
    private var refresher: UIRefreshControl!
    
    var userInfo: User! {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView else { return }
                tableView.reloadData()
            }
            self.getImage()
        }
    }
    
    private var avatarImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView, oldValue != self.avatarImage else { return }
                tableView.reloadData()
            }
        }
    }
    
    private var repos = [Repos]() {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView, oldValue != self.repos else { return }
                tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
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
    private func setupUI() {
        let searchController = UISearchController(searchResultsController: SearchViewController())
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = SearchType.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self

        definesPresentationContext = true
        navigationItem.searchController = searchController
        let button = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        let settings = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings(sender:)))
        navigationItem.leftBarButtonItem = button
        navigationItem.rightBarButtonItem = settings
        title = "Profile"
    }
    
    private func getImage() {
        NetworkManager.downloadImage(url: userInfo.avatar_url) { (result) in
            self.avatarImage = result
        }
    }
    
    @objc private func openSettings(sender: UIBarButtonItem!) {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func showInfo(sender: UIButton) {
        let repo = repos[sender.tag]
        let text = "\(repo.private ? "Private" : "Public")\(repo.fork ? ", Forked" : "")"
        let vc = InfoViewController()
        vc.text = text
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 10 * text.count, height: 22)
        guard let ppc = vc.popoverPresentationController else { return }
        ppc.delegate = self
        ppc.sourceView = sender
        ppc.backgroundColor = .white
        
        present(vc, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.selectionStyle = .none
            guard let userInfo = userInfo else { return cell }
            cell.nameLabel.text = userInfo.name
            cell.profileImage.image = avatarImage
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReposCell
            let repo = repos[indexPath.row]
            cell.nameLabel.text = repo.name
            cell.infoButton.addTarget(self, action: #selector(showInfo(sender:)), for: .touchUpInside)
            cell.infoButton.tag = indexPath.row
            cell.updateLabel.text = "Last Update: \(repo.updated_at!.convertData())"
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return repos.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
            let repoName = repos[indexPath.row].name
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepoVC") as! RepoViewController
            vc.repoName = repoName
            vc.owner = userInfo.login
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - PopoverVC
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let resultController = searchController.searchResultsController as? SearchViewController else { return }
        let searchType = SearchType(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
        guard let type = searchType, let text = searchBar.text else { return }
        authService.search(type: type, request: text) { (repo, users, code) in
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
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
