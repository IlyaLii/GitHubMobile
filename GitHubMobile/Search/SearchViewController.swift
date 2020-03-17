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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        switch type {
            case .code:
                cell.textLabel?.text = result.2?.items[indexPath.row].name
                cell.detailTextLabel?.text = result.2?.items[indexPath.row].repository.name
            case .commits: return cell
            case .repositories: return repoCell(tableView: tableView, indexPath: indexPath)
            case .users: cell.textLabel?.text = result.1?.items[indexPath.row].login
            case .none: return cell
        }
        
        return cell
    }
    
    func repoCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReposCell", for: indexPath) as! ReposCell
        guard let item = result.0?.items[indexPath.row] else { return cell }
        cell.updateLabel.text = "Last Update: \(item.updated_at!.convertData())"
       // cell.nameLabel.text = item.name
        
        return cell
    }
}
