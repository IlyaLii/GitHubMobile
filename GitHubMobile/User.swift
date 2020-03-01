//
//  User.swift
//  GitHubMobile
//
//  Created by Li on 3/1/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct User: Decodable {
    var avatar_url: String
    var name: String
    var company: String?
    var blog: String?
    var email: String?
    var bio: String?
}

