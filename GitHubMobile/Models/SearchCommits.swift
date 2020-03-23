//
//  SearchCommits.swift
//  GitHubMobile
//
//  Created by Li on 3/23/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct SearchCommits: Decodable {
    var items: [ItemCommit]?
}

struct ItemCommit: Decodable {
    var commit: Commit
    var committer: User?
}
