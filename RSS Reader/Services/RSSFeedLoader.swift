//
//  RSSFeedLoader.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import Foundation
import FeedKit

enum LoadingError : Error {
    case networkingError(Error)
    case requestFailed(Int)
    case serverError(Int)
    case notFound
    case feedParsingError(Error)
    case missingAttribute(String)
}

class FeedLoader {
    
    func fetch(feed: URL, completion: @escaping (Channel, [Item], LoadingError) -> Void) {
        let request = URLRequest(
            url: feed,
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: 60
        )
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.networkingError(error)))
                }
                return
            }
            
            let http = response as! HTTPURLResponse
            switch http.statusCode {
            case 200:
                if let data = data {
                    self.loadFeed(data: data, completion: completion)
                }
                
            case 404:
                DispatchQueue.main.async {
                    completion(.failure(.notFound))
                }
                
            case 500...599:
                DispatchQueue.main.async {
                    completion(.failure(.serverError(http.statusCode)))
                }
                
            default:
                DispatchQueue.main.async {
                    completion(.failure(.requestFailed(http.statusCode)))
                }
            }
        }
    }
    
    private func loadFeed(data: Data, completion: @escaping (Channel, [Item], LoadingError) -> Void) {
        let parser = FeedParser(data: data)
        parser.parseAsync { parseResult in
            let result: Swift.Result<Podcast, PodcastLoadingError>
            do {
                switch parseResult {
                case .atom(let atom):
                    result = try .success(self.convert(atom: atom))
                case .rss(let rss):
                    result = try .success(self.convert(rss: rss))
                case .json(_): fatalError()
                case .failure(let e):
                    result = .failure(.feedParsingError(e))
                }
            } catch let e as PodcastLoadingError {
                result = .failure(e)
            } catch {
                fatalError()
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func convert(rss: RSSFeed) throws -> Podcast {
        guard let title = rss.title else { throw PodcastLoadingError.missingAttribute("title") }
        guard let author = rss.iTunes?.iTunesOwner?.name else {
            throw PodcastLoadingError.missingAttribute("itunes:owner name")
        }
        let description = rss.description ?? ""
        guard let logoURL = rss.iTunes?.iTunesImage?.attributes?.href.flatMap(URL.init) else {
            throw PodcastLoadingError.missingAttribute("itunes:image url")
        }
        
        let p = Podcast()
        p.title = title
        p.author = author
        p.artworkURL = logoURL
        p.description = description
        return p
    }
}




