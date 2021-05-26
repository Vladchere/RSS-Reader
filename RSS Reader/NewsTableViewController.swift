//
//  NewsTableViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    fileprivate let feedParser = FeedParser()
    fileprivate let feedURL = "https://www.apple.com/main/rss/hotnews/hotnews.rss"
    fileprivate var rssItems: [(title: String, description: String, pubDate: String)]?
//    fileprivate var cellStates: [CellState]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 120
        
//        tableView.estimatedRowHeight = 140
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        feedParser.parseFeed(feedURL: feedURL) { [weak self] rssItems in
            self?.rssItems = rssItems
//            self?.cellStates = Array(repeating: .collapsed, count: rssItems.count)
            
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        cell.configure()
        
        if let item = rssItems?[indexPath.row] {
            (cell.channelTitleLable.text, cell.itemTitleLabel.text) = (item.title, item.description)
        }
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
//        
//        tableView.beginUpdates()
//        cell.descriptionLabel.numberOfLines = cell.descriptionLabel.numberOfLines == 4 ? 0 : 4
//        cellStates?[indexPath.row] = cell.descriptionLabel.numberOfLines == 4 ? .collapsed : .expanded
//        tableView.endUpdates()
    }
}
