//
//  Code.swift
//  GitHubMobile
//
//  Created by Li on 3/15/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct Code: Decodable {
    var git_url: String
    var name: String
    var repository: Repos
}
