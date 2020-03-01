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
                self.tableView.reloadData()
            }
        }
    }
    //private var repos:
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AuthService()
        if userInfo == nil {
            authService.userInfo { (result) in
                switch result {
                case.success(let user): self.userInfo = user
                case.failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(error: error.rawValue)
                    }
                }
            }
        }
        setupUI()
    }
    
    private func setupUI() {
        let button = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = button
        title = "Profile"
    }
    
    private func showAlert(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            guard let userInfo = userInfo else { return cell }
            cell.nameLabel.text = userInfo.name
            cell.statusLabel.text = userInfo.bio
            cell.workLabel.text = userInfo.company
            cell.emailLabel.text = userInfo.email
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
             return 150
        } else {
            return 44
        }
    }

}
