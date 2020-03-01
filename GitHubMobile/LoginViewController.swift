//
//  LoginViewController.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private var authService: AuthService!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.layer.borderWidth = 2
    }
    
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if emailTF.text == "" || passwordTF.text == "" { return }
        authService = AuthService(login: emailTF.text!, password: passwordTF.text!)
        authService.userInfo { (result) in
            switch result {
            case .success(let user): print(user)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(error: error.localizedDescription)
                }
            }
        }
    }
    
    func showAlert(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
