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
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .code: return result.2!.total_count
        case .commits: return 0
        case .repositories: return result.0!.total_count
        case .users: return result.1!.total_count
        case .none: return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        switch type {
            case .code: cell.textLabel?.text = result.2?.items[indexPath.row].content
            case .commits: return cell
            case .repositories: cell.textLabel?.text = result.0?.items[indexPath.row].name
            case .users: cell.textLabel?.text = result.1?.items[indexPath.row].name
            case .none: return cell
        }


        return cell
    }
}
