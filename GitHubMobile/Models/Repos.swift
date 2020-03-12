//
//  Repos.swift
//  GitHubMobile
//
//  Created by Li on 3/3/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

struct Repos: Decodable, Equatable {

    var name: String
    var `private`: Bool
    var fork: Bool
    var updated_at: String
        
}
