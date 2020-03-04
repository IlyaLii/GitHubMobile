//
//  InfoViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/4/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    var text: String! {
        didSet {
            self.label.text = text
        }
    }
    private var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label.frame = CGRect(origin: .zero, size: preferredContentSize)
        view.addSubview(label)
    }
}
