//
//  FeedManager.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 27.05.2021.
//

import Foundation
import FeedKit

class FeedLoader {
    
    static let shared = FeedLoader()
    private init() {}
    
    func fetchFeed(from stringUrl: String, completionHandler: @escaping (RSSFeed?) -> ()){
        
        guard let url = URL(string: stringUrl) else { return }
        let parser = FeedParser(URL: url)
        
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                completionHandler(feed.rssFeed)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

