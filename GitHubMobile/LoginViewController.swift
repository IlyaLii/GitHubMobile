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
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(sender:)))
        view.addGestureRecognizer(tap)
        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.layer.borderWidth = 1
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func hideKeyboard(sender: UITapGestureRecognizer) {
           self.view.endEditing(true)
       }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if emailTF.text == "" || passwordTF.text == "" { return }
        authService = AuthService(login: emailTF.text!, password: passwordTF.text!)
        userInfo()
    }
    
    private func userInfo() {
        authService.userInfo { (result) in
            switch result {
            case .success(let user):
                self.authService.setProfile()
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    vc.userInfo = user
                    self.passwordTF.text = ""
                    self.emailTF.text = ""
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.rawValue)
                }
            }
        }
    }
}
