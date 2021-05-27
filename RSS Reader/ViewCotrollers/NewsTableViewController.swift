//
//  NewsTableViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import UIKit
import FeedKit


//let feedURL = URL(string: "https://lenta.ru/rss/articles")!

class NewsTableViewController: UITableViewController {
    
    var rssFeed: RSSFeed?
    var items: [RSSFeedItem]?
    var showItems: [RSSFeedItem] = []
    var isFetchFeed = true
    let stringURL = "https://lenta.ru/rss/articles"
    
    

//    let parser = FeedParser(URL: feedURL)
//    var rssFeed: RSSFeed?
//    var imageUrls: [String?] = []
    
//    var fetchingMore = false
//    var feedDownload = false
//    var items = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        FeedClient.shared.fetchFeed(from: self.stringURL) { rssFeed, items in
            DispatchQueue.main.async {
                self.rssFeed = rssFeed
                self.items = items
                self.tableView.reloadData()
            }
        }
        
//        parser.parseAsync { [weak self] (result) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let feed):
//                self.rssFeed = feed.rssFeed
//
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    self.feedDownload.toggle()
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
//        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
            return self.rssFeed?.items?.count ?? 0
//        } else if section == 1 && isFetchFeed {
//            return 1
//        }
//        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            cell.configure(rssFeed: self.rssFeed, rowCount: indexPath.row)
            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
//            cell.activityIndicator.startAnimating()
//            return cell
//        }
        
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if offsetY > contentHeight - scrollView.frame.height {
//            if !isFetchFeed {
//                beginFetch()
//            }
//        }
//    }
    
//    private func beginFetch() {
//        isFetchFeed = true
//
//        tableView.reloadSections(IndexSet(integer: 1), with: .none)
//
//        guard let items = items else { return }
//
//        for (index, item) in items.enumerated() {
//            if index < 10 && showItems.count < 10  {
//                showItems.append(item)
//            } else {
//                let newItems = items[index]
//                showItems.append(newItems)
//            }
//        }
//
//        self.isFetchFeed = false
//        self.tableView.reloadData()
//    }
    
    private func setUI() {
        self.title = "Feed"
        tableView.rowHeight = 130
    }
}

