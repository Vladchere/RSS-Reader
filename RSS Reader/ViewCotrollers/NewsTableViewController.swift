//
//  NewsTableViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import UIKit
import FeedKit

// MARK: - Source
let rssChannel = "https://lenta.ru/rss/articles"

class NewsTableViewController: UITableViewController {
    
    // MARK: - Private properties
    private var rssFeed: RSSFeed?
    private var fetchingMore = false
    private var items = [RSSFeedItem]()
    private var paginagionCounter = 0
    private var chunkedFeedItems: [[RSSFeedItem]]?
    private var isLastItems = false
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCell")
        
        FeedLoader.shared.fetchFeed(from: rssChannel) { rssFeed in
            self.rssFeed = rssFeed
            
            if let feedItems = self.rssFeed?.items {
                self.chunkedFeedItems = feedItems.chunked(by: 6)
            }
            
            DispatchQueue.main.async {
                self.title = self.rssFeed?.title ?? "News"
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.items.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            cell.configure(rssFeed: self.rssFeed, rssItems: self.items, index: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else {
            return 40
        }
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) && !fetchingMore {
            loadMoreData()
        }
    }
    
    // MARK: - Private methods
    private func loadMoreData() {
        
        if !self.fetchingMore {
            self.fetchingMore = true
            
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            
            /*
             Мы используем xml(все items прогружаются сразу)
             
             и не можем использовать параметры при запросах
             (в некоторых запросах можно указать количество загружаемых элементов)
             
             сделал пример имитирующий фоновую загрузку, чтобы показать ячейку с индикатором загрузки
             (тк использую массивы, данные прогружаются почти мнгновенно и не видно индикатора)
             */
            DispatchQueue.global().async {
                sleep(2)
                
                if ((self.chunkedFeedItems?.count ?? 0) - 1) == self.paginagionCounter {
                    
                    if self.isLastItems {
                        return
                    } else {
                        self.items += self.chunkedFeedItems?.last ?? []
                        self.isLastItems = true
                    }
                    
                } else {
                    self.items += self.chunkedFeedItems?[self.paginagionCounter] ?? []
                    self.paginagionCounter += 1
                }
                
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
}

extension Collection {
    
    func chunked(by distance: Int) -> [[Element]] {
        precondition(distance > 0, "distance must be greater than 0")

        var index = startIndex
        let iterator: AnyIterator<Array<Element>> = AnyIterator({
            let newIndex = self.index(index, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex
            defer { index = newIndex }
            let range = index ..< newIndex
            return index != self.endIndex ? Array(self[range]) : nil
        })
        
        return Array(iterator)
    }
}
