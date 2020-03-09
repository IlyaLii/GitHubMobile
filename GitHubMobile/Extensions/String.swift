//
//  String.swift
//  GitHubMobile
//
//  Created by Li on 3/3/20.
//  Copyright © 2020 Li. All rights reserved.
//

import Foundation

extension String {
    func convertData() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: self) else { return "" }
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "d MMMM, yyyy"
        return newFormatter.string(from: date)
    }
    
    func pathExtension() -> String {
        let temp = self as NSString
        return temp.pathExtension
    }
}
