//
//  SettingsViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/12/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

enum SettingsRows: String, CaseIterable {
    case exit = "Exit"
}

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "settingsIdentifier")
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsRows.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsIdentifier", for: indexPath) as! SettingsCell
        cell.type = SettingsRows.allCases[indexPath.row]
        switch cell.type {
        case .exit: cell.textLabel?.textColor = .systemRed
        case .none: break
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SettingsCell
        switch cell.type {
        case .exit:
            AuthService.removeProfile()
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            let navigationVC = UINavigationController(rootViewController: loginVC)
            navigationVC.modalPresentationStyle = .fullScreen
            present(navigationVC, animated: true, completion: nil)
        case .none: break
            
        }
        
    }
}
