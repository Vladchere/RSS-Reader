//
//  FeedItemWebViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 31.05.2021.
//

import UIKit
import WebKit

class FeedItemWebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    var selectedFeedURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: " ", with:"")
        selectedFeedURL =  selectedFeedURL?.replacingOccurrences(of: "\n", with:"")
        
        if let stringUrl = selectedFeedURL, let url = URL(string: stringUrl) {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear( animated )
    }
}
