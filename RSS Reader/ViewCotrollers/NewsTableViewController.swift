//
//  NewsTableViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import UIKit
import FeedKit

let feedURL = URL(string: "https://lenta.ru/rss/articles")!

class NewsTableViewController: UITableViewController {
    
    let parser = FeedParser(URL: feedURL)
    var rssFeed: RSSFeed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Feed"
        tableView.rowHeight = 150
        
        parser.parseAsync { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let feed):
                self.rssFeed = feed.rssFeed
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssFeed?.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        cell.channelTitleLabel?.text = self.rssFeed?.title ?? "[no title]"
        cell.itemTitleLable?.text = self.rssFeed?.items?[indexPath.row].title ?? "[no title]"
        cell.itemDescriptionLabel?.text = self.rssFeed?.title ?? "[no title]"
        cell.itemPubDateLabel?.text = self.rssFeed?.title ?? "[no title]"
        cell.itemPubDateLabel?.text = self.rssFeed?.link ?? "[no link]"
        
        cell.imageView?.image = UIImage(systemName: "pencil")
        
        return cell
    }
}

