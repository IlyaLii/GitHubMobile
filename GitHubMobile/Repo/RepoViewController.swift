//
//  RepoViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/3/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class RepoViewController: UITableViewController {

    var repoName: String!
    var owner: String!
    private var branchs = [Branch]()
    private var selectedBranch = "master"
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AuthService.shared
        setupModels()
        title = repoName
        let button = UIBarButtonItem(title: "Branch", style: .plain, target: self, action: #selector(branchTapped(sender:)))
        navigationItem.rightBarButtonItem = button
    }

    func setupModels() {
        guard let repoName = repoName else { return }
        guard let owner = owner else { return }
        authService.branchsInfo(owner: owner, nameRepo: repoName) { (result) in
            switch result {
            case.success(let branchs):
                self.branchs = branchs
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.rawValue)
                }
            }
        }
    }
    
    @objc func branchTapped(sender: UIBarButtonItem!) {
        let vc = PopOverViewController()
        vc.modalPresentationStyle = .popover
        vc.branchs = branchs
        vc.preferredContentSize = CGSize(width: 150, height: 45 * branchs.count)
        guard let ppc = vc.popoverPresentationController else { return }
        ppc.delegate = self
        ppc.permittedArrowDirections = .up
        ppc.sourceRect = CGRect(x: view.frame.width, y: 0, width: 0, height: 0)
        ppc.sourceView = self.view
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)

        // Configure the cell...

        return cell
    }
}

extension RepoViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
