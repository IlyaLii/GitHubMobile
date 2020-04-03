//
//  SearchViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/15/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    var result: (SearchRepo?, SearchUsers?, SearchCode?, SearchCommits?)
    var type: SearchType! 
    
    private var loadingView = UIView()
    private var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CommitCell.self, forCellReuseIdentifier: "CommitCell")
        tableView.register(ReposCell.self, forCellReuseIdentifier: "ReposCell")
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = type else { return 0 }
        switch type {
        case .code: return result.2!.items?.count ?? 0
        case .commits: return result.3!.items?.count ?? 0
        case .repositories: return result.0!.items?.count ?? 0
        case .users: return result.1!.items?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = type else { return UITableViewCell()}
        switch type {
        case .code: return codeCell(tableView: tableView, indexPath: indexPath)
        case .commits: return commitCell(tableView: tableView, indexPath: indexPath)
        case .repositories: return repoCell(tableView: tableView, indexPath: indexPath)
        case .users: return userCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case .repositories:
            guard let repo = result.0?.items?[indexPath.row] else { return }
            tableView.deselectRow(at: indexPath, animated: true)
            let repoName = repo.name
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepoVC") as! RepoViewController
            vc.repoName = repoName
            vc.owner = repo.owner.login
            presentingViewController?.navigationController?.pushViewController(vc, animated: true)
        case .code:
            guard let code = result.2?.items?[indexPath.row] else { return }
            tableView.deselectRow(at: indexPath, animated: true)
            NetworkManager.getData(url: code.git_url) { (data) in
                DispatchQueue.main.async {
                    let vc = WebViewController()
                    vc.data = data
                    vc.pathExtension = code.path.pathExtension()
                    vc.title = code.path
                    self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        case .users:
            guard let user = result.1?.items?[indexPath.row] else { return }
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
            let vc = BaseMainViewController()
            vc.userInfo = user
            vc.avatarImage = cell.profileImage.image
            self.presentingViewController?.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }
    
    func repoCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
        guard indexPath.row <= (result.0?.items!.count)!  else { return cell }
        guard let item = result.0?.items?[indexPath.row] else { return cell }
        cell.updateLabel.text = "Last Update: \(item.updated_at!.convertData())"
        cell.nameLabel.text = "\(item.owner.login)/\(item.name)"
        cell.infoButton.addTarget(self, action: #selector(showInfo(sender:)), for: .touchUpInside)
        cell.infoButton.tag = indexPath.row
        return cell
    }
    
    func codeCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
        guard indexPath.row <= (result.2?.items!.count)!  else { return cell }
        guard let item = result.2?.items?[indexPath.row] else { return cell }
        cell.updateLabel.text = item.path
        cell.nameLabel.text = item.repository.name
        cell.infoButton.isHidden = true
        return cell
    }
    
    func userCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.profileImage.image = nil
        guard indexPath.row <= (result.1?.items!.count)!  else { return cell }
        guard let item = result.1?.items?[indexPath.row] else { return cell }
        NetworkManager.downloadImage(url: item.avatar_url) { (result) in
            DispatchQueue.main.async {
                cell.profileImage.image = result
            }
        }
        cell.nameLabel.text = item.login
        return cell
    }
    
    func commitCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommitCell", for: indexPath) as! CommitCell
        guard indexPath.row <= (result.3?.items!.count)!  else { return cell }
        guard let item = result.3?.items?[indexPath.row] else { return cell }
        cell.messageLabel.text = item.commit.message
        cell.repoLabel.text = "\(item.commit.tree.path ?? "")/\(item.committer?.login)"
        cell.infoLabel.text = "fdslmf"
        return cell
    }
    
    @objc private func showInfo(sender: UIButton) {
        guard let repo = result.0?.items?[sender.tag] else { return }
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
    
    func setActiviyView() {
        spinner.removeFromSuperview()
        loadingView.frame = UIScreen.main.bounds
        loadingView.backgroundColor = .white
        spinner.center = CGPoint(x: loadingView.center.x, y: loadingView.center.y - (presentingViewController?.navigationController?.navigationBar.frame.maxY ?? 0 + spinner.frame.height))
        spinner.startAnimating()
        loadingView.addSubview(spinner)
        view.addSubview(loadingView)
    }
    
    func removeActivityView() {
        loadingView.removeFromSuperview()
    }
}

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
