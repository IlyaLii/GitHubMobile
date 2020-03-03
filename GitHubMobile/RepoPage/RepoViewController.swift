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
    private var tree = [Tree]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var selectedBranch = "master"
    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AuthService.shared
        setupTreeModel()
        setupBranchModel()
        title = repoName
        let button = UIBarButtonItem(title: "Branch", style: .plain, target: self, action: #selector(branchTapped(sender:)))
        navigationItem.rightBarButtonItem = button
    }
    
    private func setupBranchModel() {
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
    
    private func setupTreeModel() {
        authService.treeInfo(owner: owner, nameTree: selectedBranch, nameRepo: repoName) { (result) in
            switch result {
            case.success(let tree):
                self.tree = tree
            case.failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.rawValue)
                }
            }
        }
    }
    
    @objc func branchTapped(sender: UIBarButtonItem!) {
        let vc = PopOverViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.branchs = branchs
        vc.preferredContentSize = CGSize(width: 150, height: 45 * branchs.count)
        guard let ppc = vc.popoverPresentationController else { return }
        ppc.delegate = self
        ppc.barButtonItem = sender
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tree.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        cell.textLabel?.text = tree[indexPath.row].path
        return cell
    }
}

extension RepoViewController: UIPopoverPresentationControllerDelegate, PopOverViewControllerDelegate {
    
    
    
    //MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: - PopOverViewControllerDelegate
    
   func changeBranch(name: String) {
        selectedBranch = name
        setupTreeModel()
    }
}
