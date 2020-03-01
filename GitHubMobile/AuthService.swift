//
//  AuthService.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

class AuthService {
    
    private var login: String?
    private var password: String?
    private var loginData: String!
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
        let stringData = "\(login):\(password)"
        guard let loginData = stringData.data(using: .utf8)?.base64EncodedString() else { return }
        self.loginData = loginData
    }
    
    init() {
        guard let loginData = AuthService.getProfile() else { return }
        self.loginData = loginData
    }
    
    func userInfo(completionHandler: @escaping(Result<User, AuthError>) -> Void) {
        
        guard let url = URL(string: "https://api.github.com/user") else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                completionHandler(.failure(.noInternet))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completionHandler(.success(user))
            } catch {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
}

extension AuthService {
    func setProfile() {
        let defaults = UserDefaults.standard
        defaults.set(loginData, forKey: "Profile")
    }
    
    static func removeProfile() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Profile")
    }
    
    static func getProfile() -> String? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: "Profile") as! String?
    }
}

