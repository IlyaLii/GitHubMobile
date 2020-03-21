//
//  LoginViewController.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private var authService: AuthService!
    private var flagKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.delegate = self
        emailTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(upUI), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(downUI), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardView(sender:)))
        view.addGestureRecognizer(tap)
        setupUI()
    }
    
    private func setupUI() {
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.layer.borderWidth = 1
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func hideKeyboardView(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func upUI(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            if self.loginButton.frame.origin.y > endFrameY {
                flagKeyboard = true
                self.topConstraint.constant -= 100
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func downUI(notification: NSNotification) {
        if flagKeyboard {
            self.topConstraint.constant += 100
            self.view.layoutIfNeeded()
        }
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
                    let vc = MainViewController()
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}
