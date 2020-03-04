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
        
        session.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }.resume()
    }
    
    static func downloadBase64Image(url: String, completionHandler: @escaping(UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        let sesion = URLSession.shared
        
        sesion.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            guard let json = try? JSONDecoder().decode(Blob.self, from: data) else { return }
            guard let dataDecode = Data(base64Encoded: json.content, options: .ignoreUnknownCharacters) else { return }
            guard let image = UIImage(data: dataDecode) else { return }
            completionHandler(image)
        }.resume()
    }
}
