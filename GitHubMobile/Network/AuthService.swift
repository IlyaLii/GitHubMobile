//
//  AuthService.swift
//  GitHubMobile
//
//  Created by Li on 2/29/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

final class AuthService {
    
    static let shared = AuthService()
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
    
    private init() {
        guard let loginData = AuthService.getProfile() else { return }
        self.loginData = loginData
    }
    
    //MARK: -MainViewController
    func userInfo(completionHandler: @escaping(Result<User, NetworkingError>) -> Void) {
        
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
    
    func reposInfo(completionHandler: @escaping(Result<[Repos], NetworkingError>) -> Void) {
        guard let url = URL(string: "https://api.github.com/user/repos") else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                completionHandler(.failure(.noInternet))
                return
            }
            
            do {
                let repos = try JSONDecoder().decode([Repos].self, from: data)
                completionHandler(.success(repos))
            } catch {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
    
    //MARK: - RepoViewController
    
    func branchsInfo(owner: String, nameRepo: String, completionHandler: @escaping(Result<[Branch], NetworkingError>) -> Void) {
        guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(nameRepo)/branches") else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.noInternet))
                return
            }
            
            do {
                let branchs = try JSONDecoder().decode([Branch].self, from: data)
                completionHandler(.success(branchs))
            } catch {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
    
    func treeInfo(owner: String, nameTree: String, nameRepo: String, completionHandler: @escaping(Result<[Tree], NetworkingError>) -> Void) {
        guard let url = URL(string: "https://api.github.com/repos/\(owner)/\(nameRepo)/git/trees/\(nameTree)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.noInternet))
                return
            }
            
            do {
                let infoTree = try JSONDecoder().decode(InfoTree.self, from: data)
                let tree = infoTree.tree
                completionHandler(.success(tree))
            } catch {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
    
    func treeInfoInTree(url: String, completionHandler: @escaping(Result<[Tree], NetworkingError>) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.noInternet))
                return
            }
            
            do {
                let infoTree = try JSONDecoder().decode(InfoTree.self, from: data)
                let tree = infoTree.tree
                completionHandler(.success(tree))
            } catch {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
    
    func backInfoInTree(url: String, completionHandler: @escaping(Result<[Tree], NetworkingError>) -> Void) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.noInternet))
                return
            }
            
            do {
                let infoTree = try JSONDecoder().decode(InfoTree.self, from: data)
                let tree = infoTree.tree
                completionHandler(.success(tree))
            } catch {
                completionHandler(.failure(.wrongData))
            }
        }.resume()
    }
    
    func search(type: SearchType, request: String, completionHandler: @escaping(SearchRepo?, SearchUsers?, SearchCode?) -> Void) {
        var url = URL(string: "https://api.github.com")
        if type == .code {
            url = URL(string: "search/\(type.rawValue)?q=\(request)+user:IlyaLii", relativeTo: url)
        } else {
            url = URL(string: "search/\(type.rawValue)?q=\(request)", relativeTo: url)
        }
        guard let fullUrl = url else { return }
        var request = URLRequest(url: fullUrl)
        request.setValue("Basic \(loginData!)", forHTTPHeaderField: "Authorization")
        if type == .commits {
            request.setValue("application/vnd.github.cloak-preview", forHTTPHeaderField: "Accept")
        }
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                switch type {
                case .code:
                    let result = try JSONDecoder().decode(SearchCode.self, from: data)
                    completionHandler(nil, nil, result)
                case .commits: break
                case .repositories:
                    let result = try JSONDecoder().decode(SearchRepo.self, from: data)
                    completionHandler(result, nil, nil)
                case .users:
                    let result = try JSONDecoder().decode(SearchUsers.self, from: data)
                    completionHandler(nil, result, nil)
                }
                
            } catch {
                print("Search Error, \(error.localizedDescription)")
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

