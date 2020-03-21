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
    private var branchs = [Branch]() {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.refresher.endRefreshing()
                guard oldValue != self.branchs else { return }
                self.tableView.reloadData()
            })
        }
    }
    private var trees = [Tree]() {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.refresher.endRefreshing()
                guard oldValue != self.trees else { return }
                self.tableView.reloadData()
            })
        }
    }
    private var folderURL = [String]()
    private var selectedBranch = "master"
    private var authService: AuthService!
    private var refresher: UIRefreshControl!
    private var folderFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AuthService.shared
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.addSubview(refresher)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RepoCell")
        setupTreeModel()
        setupBranchModel()
        title = repoName
        let button = UIBarButtonItem(title: "Branch", style: .plain, target: self, action: #selector(branchTapped(sender:)))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func update() {
        setupBranchModel()
        if folderFlag {
            
        } else {
            setupTreeModel()
        }
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
    
    @objc private func setupTreeModel() {
        authService.treeInfo(owner: owner, nameTree: selectedBranch, nameRepo: repoName) { (result) in
            switch result {
            case.success(let trees):
                self.trees = trees
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
        return trees.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        cell.textLabel?.text = trees[indexPath.row].path
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tree = trees[indexPath.row]
        let folderString = "..."
        if tree.path == folderString {
            if folderURL.count == 1 {
                setupTreeModel()
                folderFlag = false
                folderURL.removeAll()
                return
            } else if folderURL.count > 1 {
                folderURL.removeLast()
            }
            guard let url = folderURL.last else { return }
            authService.backInfoInTree(url: url) { (result) in
                switch result {
                case.success(let trees):
                    self.trees = trees
                    if self.trees.first?.path != folderString {
                        self.trees.insert(Tree(path: folderString, url: nil, type: ""), at: 0)
                    }
                case.failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.rawValue)
                    }
                }
            }
        }
        
        if tree.type == "tree" {
            guard let url = tree.url else { return }
            authService.treeInfoInTree(url: url) { (result) in
                switch result {
                case.success(let trees):
                    self.trees = trees
                    if self.trees.first?.path != folderString {
                        self.trees.insert(Tree(path: folderString, url: nil, type: ""), at: 0)
                        self.folderFlag = true
                    }
                    self.folderURL.append(url)
                case.failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.rawValue)
                    }
                }
            }
        }
        
        if tree.type == "blob" {
            guard let url = tree.url else { return }
            NetworkManager.getData(url: url) { data in
                DispatchQueue.main.async {
                    let vc = WebViewController()
                    vc.data = data
                    vc.pathExtension = tree.path.pathExtension()
                    vc.title = tree.path
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
