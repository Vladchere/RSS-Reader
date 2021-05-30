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
    
    func fetchFeed(from url: URL, completionHandler: @escaping (RSSFeed?) -> ()){
        
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

