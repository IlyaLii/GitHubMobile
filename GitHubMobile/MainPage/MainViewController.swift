//
//  MainViewController.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private var authService: AuthService!
    
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
                guard let tableView = self.tableView else { return }
                tableView.reloadData()
            }
        }
    }
    
    private var repos = [Repos]() {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView else { return }
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
    
    private func setupModels() {
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
                repos.sort {$0.updated_at > $1.updated_at}
                self.repos = repos
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.rawValue)
                }
            }
        }
    }
    private func setupUI() {
        let button = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = button
        title = "Profile"
    }
    
    private func getImage() {
        NetworkManager.downloadImage(url: userInfo.avatar_url) { (result) in
            self.avatarImage = result
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
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
            cell.privacyLabel.text = "\(repo.private ? "Private" : "Public")\(repo.fork ? ", Forked" : "")"
            cell.updateLabel.text = "Last Update: \(repo.updated_at.convertData())"
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
}
