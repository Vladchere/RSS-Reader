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
    @IBOutlet weak var newsImageView: ImageView!
    
    func configure(rssFeed: RSSFeed?, rssItems: [RSSFeedItem], index: Int) {
        
        channelTitleLabel?.text = rssFeed?.title ?? "No title"
        itemTitleLable?.text = rssItems[index].title ?? "No items"
        
        let pubDate = rssItems[index].pubDate
        itemPubDateLabel.text = DateFormater.shared.format(date: pubDate)
        
        let imageUrlString = rssItems[index].enclosure?.attributes?.url ?? "No image"
        newsImageView.fetchImage(from: imageUrlString)
    }
}



