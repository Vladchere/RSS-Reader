//
//  NewsTableViewCell.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 27.05.2021.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var itemTitleLable: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPubDateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
}
