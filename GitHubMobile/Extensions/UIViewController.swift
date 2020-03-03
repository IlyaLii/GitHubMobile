//
//  UIViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/3/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
