//
//  WebViewController.swift
//  GitHubMobile
//
//  Created by Li on 3/9/20.
//  Copyright © 2020 Li. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController {
    
    private var wkWebView = WKWebView()
    var data: Data? = nil
    var pathExtension: String?
    override func loadView() {
        view = wkWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        guard let data = data,
              let pathExtension = pathExtension else { return }
        
        wkWebView.load(data,
                       mimeType: NetworkManager.mimeTypeForPath(pathExtension: pathExtension),
                       characterEncodingName: "base64",
                       baseURL: NSURL() as URL)
    }
}
