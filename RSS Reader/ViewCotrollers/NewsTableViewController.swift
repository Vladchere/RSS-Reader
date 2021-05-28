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
    private var itemsCount = 0
    private var chunkedFeedItems: [[RSSFeedItem]]?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        FeedLoader.shared.fetchFeed(from: rssChannel) { rssFeed in
            self.rssFeed = rssFeed
            self.itemsCount = rssFeed?.items?.count ?? 0
            
            if let feedItems = self.rssFeed?.items {
                self.chunkedFeedItems = feedItems.chunked(into: 10)
                self.items = self.chunkedFeedItems?[self.paginagionCounter] ?? []
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        tableView.register(
            UINib(nibName: "LoadingCell", bundle: nil),
            forCellReuseIdentifier: "loadingCell"
        )
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
            cell.activityIndicator?.startAnimating()
            return cell
        }
        
    }
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
                beginFetch()
            }
        }
    }
    
    // MARK: - Private methods
    private func beginFetch() {
        fetchingMore = true
        
        
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        
        /*
         Мы используем xml(все items прогружаются сразу)
         
         и не можем использовать параметры при запросах
         (в некоторых запросах можно указать количество загружаемых элементов)
         
         сделал пример имитирующий асинхронную загрузку, чтобы показать ячейку с индикатором загрузки
         (тк использую массивы, данные прогружаются почти мнгновенно и не видно индикатора)
         */
        self.paginagionCounter += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.paginagionCounter < self.chunkedFeedItems?.count ?? 1 {
                self.items = self.chunkedFeedItems?[self.paginagionCounter] ?? []
            }
            
            self.fetchingMore = false
            self.tableView.reloadData()
        }
    }
    
    private func setUI() {
        self.title = "Feed"
        tableView.rowHeight = 130
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
