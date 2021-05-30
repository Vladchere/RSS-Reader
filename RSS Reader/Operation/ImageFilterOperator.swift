//
//  ImageFilterOperator.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import UIKit
import CoreImage

enum Filters: String, CaseIterable {
    case Fade = "CIPhotoEffectFade"
    case Mono = "CIPhotoEffectMono"
    case Chrome = "CIPhotoEffectChrome"
    case Sepia = "CISepiaTone"
    case Blur = "CIGaussianBlur"
}

class ImageFilterOperation: Operation {
    let context = CIContext(options: nil)
    var processedImage: UIImage?
    var imageFilter = "CIPhotoEffectFade"
    
    func setFilter(from filter: String, input: UIImage) -> UIImage? {
        var inputImage = CIImage(image: input)
        
        let filters = inputImage!.autoAdjustmentFilters()

        for filter: CIFilter in filters {
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            inputImage =  filter.outputImage
        }
        
        let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
        let currentFilter = CIFilter(name: self.imageFilter)
        currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)

        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        
        return UIImage(cgImage: cgimg!)
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let dependencyImage = self.dependencies
            .compactMap { $0 as? DownloadImageOperation }
            .first
        
        if let image = dependencyImage?.outputImage {
            guard !isCancelled else { return }
            self.processedImage = self.setFilter(from: self.imageFilter, input: image)
        }
    }
}
