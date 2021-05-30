//
//  NewsTableViewCell.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 27.05.2021.
//

import UIKit



class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemTitleLable: UILabel!
    @IBOutlet weak var itemPubDateLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    
    func format(date: Date?) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.YY"
        
        if let date = date {
            return formatter.string(from: date)
        } else {
            return "No publication date"
        }
    }
    
//    func addFilter(filter: String) {
//        let context = CIContext(options: nil)
//        
//        guard let image = newsImageView.image else { return print("guard") }
//        
//        var inputImage = CIImage(image: image)
//        
//        let filters = inputImage!.autoAdjustmentFilters()
//
//        for filter: CIFilter in filters {
//            filter.setValue(inputImage, forKey: kCIInputImageKey)
//            inputImage =  filter.outputImage
//        }
//        
//        let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
//        let currentFilter = CIFilter(name: filter)
//        currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)
//    }
}


