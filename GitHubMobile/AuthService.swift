//
//  AuthService.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

class AuthService {
    
    private var login: String
    private var password: String
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    func userInfo(completionHandler: @escaping(Result<User, Error>) -> Void) {
        let stringData = "\(login):\(password)"
        guard let loginData = stringData.data(using: .utf8)?.base64EncodedString() else { return }
        
        guard let url = URL(string: "https://api.github.com/user") else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                completionHandler(.failure(error!))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completionHandler(.success(user))
            } catch let error {
                completionHandler(.failure(error))
            }
        }.resume()
    }
}

