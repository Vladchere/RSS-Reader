//
//  FeedItemWebViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 31.05.2021.
//

import UIKit
import WebKit

class DetailPublicationViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var selectedFeedURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stringUrl = selectedFeedURL, let url = URL(string: stringUrl) {
            webView.load(URLRequest(url: url))
        }
    }
}
