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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if emailTF.text == "" || passwordTF.text == "" { return }
        authService = AuthService(login: emailTF.text!, password: passwordTF.text!)
        userInfo()
    }
    
    func userInfo() {
        authService.userInfo { (result) in
            switch result {
            case .success(let user):
                self.authService.setProfile()
                DispatchQueue.main.async {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainViewController
                    vc.userInfo = user
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.passwordTF.text = ""
                    self.emailTF.text = ""
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(error: error.rawValue)
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
