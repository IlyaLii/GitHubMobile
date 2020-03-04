//
//  Tree.swift
//  GitHubMobile
//
//  Created by Li on 3/4/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct InfoTree: Decodable {
    var tree: [Tree]
}

struct Tree: Decodable {
    var path: String
    var url: String?
    var type: String
}
