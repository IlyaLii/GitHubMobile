//
//  Commit.swift
//  GitHubMobile
//
//  Created by Li on 3/22/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct Commit: Decodable {
    var message: String
    var tree: Tree
}
