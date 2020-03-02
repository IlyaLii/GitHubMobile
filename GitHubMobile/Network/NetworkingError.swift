//
//  AuthError.swift
//  GitHubMobile
//
//  Created by Li on 3/1/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

enum NetworkingError: String, Error {
    case noInternet = "Check your Internet connection"
    case wrongData = "Wrong login or password"
}
