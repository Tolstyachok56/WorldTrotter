//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Виктория Бадисова on 24.05.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import WebKit

class WebViewController: UIViewController {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.bignerdranch.com/")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
}
