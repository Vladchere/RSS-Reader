//
//  NewsTableViewCell.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 27.05.2021.
//

import UIKit
import FeedKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var itemTitleLable: UILabel!
    @IBOutlet weak var itemPubDateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    func configure(rssFeed: RSSFeed?, rowCount: Int) {
        channelTitleLabel?.text = rssFeed?.title ?? "No title"
        itemTitleLable?.text = rssFeed?.items?[rowCount].title ?? "No items"
        
        if let pubDate = rssFeed?.items?[rowCount].pubDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.YY"
            itemPubDateLabel?.text = formatter.string(from: pubDate)
        }
        
        DispatchQueue.global().async {
            guard let stringURL = rssFeed?.items?[rowCount].enclosure?.attributes?.url else { return }
            guard let imageURL = URL(string: stringURL) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
                self.newsImageView.image = UIImage(data: imageData)
            }
        }
    }
}



