//
//  SearchViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/15/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
    
    var result: (SearchRepo?, SearchUsers?, SearchCode?) {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var type: SearchType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        tableView.register(ReposCell.self, forCellReuseIdentifier: "ReposCell")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .code: return result.2!.items.count
        case .commits: return 0
        case .repositories: return result.0!.items.count
        case .users: return result.1!.items.count
        case .none: return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch type {
        case .code: break
//            cell.textLabel?.text = result.2?.items[indexPath.row].name
//            cell.detailTextLabel?.text = result.2?.items[indexPath.row].repository.name
        case .commits: break
        case .repositories: return repoCell(tableView: tableView, indexPath: indexPath)
        case .users: break
        //cell.textLabel?.text = result.1?.items[indexPath.row].login
        case .none: break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func repoCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
        guard let item = result.0?.items[indexPath.row] else { return cell }
        cell.updateLabel.text = "Last Update: \(item.updated_at!.convertData())"
        cell.nameLabel.text = item.name
        cell.infoButton.addTarget(self, action: #selector(showInfo(sender:)), for: .touchUpInside)
        cell.infoButton.tag = indexPath.row
        return cell
    }
    
    @objc private func showInfo(sender: UIButton) {
        guard let repo = result.0?.items[sender.tag] else { return }
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

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
