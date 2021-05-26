//
//  NewsTableViewCell.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import UIKit

//enum CellState {
//    case expanded
//    case collapsed
//}

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelTitleLable: UILabel!
    @IBOutlet weak var itemTitleLabel:UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    // MARK: - Public methods
    func configure() {
        newsImageView.image = UIImage(systemName: "pencil.and.outline")
        channelTitleLable.text = "Lenta.ru : Статьи"
        itemTitleLabel.text = "«Нашим детям лечь и умирать?» В России уволили спасшего сотни детей врача Каабака. Что будет с его пациентами?"
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
