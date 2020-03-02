//
//  NetworkManager.swift
//  GitHubMobile
//
//  Created by Li on 3/1/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func downloadImage(url: String, completionHandler: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, _, error) in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }.resume()
    }
}
