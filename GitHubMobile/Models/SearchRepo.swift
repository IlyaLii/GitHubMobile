//
//  Search.swift
//  GitHubMobile
//
//  Created by Li on 3/14/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct SearchRepo: Decodable {
    var items: [Repos]
    var total_count: Int
}
