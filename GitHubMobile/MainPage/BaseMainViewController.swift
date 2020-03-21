//
//  BaseMainViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/21/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class BaseMainViewController: UIViewController {

    private var tableView: UITableView!
    var userInfo: User! {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView else { return }
                tableView.reloadData()
            }
            if avatarImage == nil {
                self.getImage()
            } else {
                self.title = self.userInfo.name
            }
        }
    }
    
    var avatarImage: UIImage? {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView, oldValue != self.avatarImage else { return }
                tableView.reloadData()
            }
        }
    }
    
    var repos = [Repos]() {
        didSet {
            DispatchQueue.main.async {
                guard let tableView = self.tableView, oldValue != self.repos else { return }
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        tableView.register(ReposCell.self, forCellReuseIdentifier: "Cell")
    }
    

    private func setupUI() {
        tableView = UITableView(frame: view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
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
    
    func getImage() {
        NetworkManager.downloadImage(url: userInfo.avatar_url) { (result) in
            self.avatarImage = result
        }
    }
}

extension BaseMainViewController: UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.selectionStyle = .none
            guard let userInfo = userInfo else { return cell }
            cell.nameLabel.text = userInfo.login
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
