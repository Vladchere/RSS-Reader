//
//  NewsTableViewCell.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 27.05.2021.
//

import UIKit
import FeedKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLable: UILabel!
    @IBOutlet weak var itemPubDateLabel: UILabel!
    @IBOutlet weak var newsImageView: ImageView!
    
//    func configure(from item: RSSFeedItem) {
//
//        itemTitleLable?.text = item.title ?? "No items"
//
//        let pubDate = item.pubDate
//        itemPubDateLabel.text = DateFormater.shared.format(date: pubDate)
//
//        let imageUrlString = item.enclosure?.attributes?.url ?? "No image"
//        newsImageView.fetchImage(from: imageUrlString)
//    }
//
//    func applyFilter(from filter: Filters) {
//        print(filter)
//        newsImageView?.image = newsImageView.image?.addFilter(filter: filter)
//    }
}



