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
            
        }
    }
    
    var type: SearchType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .code: return result.2!.total_count
        case .commits: return 0
        case .repositories: return result.0!.total_count
        case .users: return result.1!.total_count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
}
