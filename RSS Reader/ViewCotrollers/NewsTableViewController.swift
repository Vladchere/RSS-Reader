//
//  NewsTableViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 26.05.2021.
//

import UIKit
import FeedKit

//enum Filters: String, CaseIterable {
//    case Chrome = "CIPhotoEffectChrome"
////    case Fade = "CIPhotoEffectFade"
////    case Instant = "CIPhotoEffectInstant"
//    case Mono = "CIPhotoEffectMono"
//    case Sepia = "CISepiaTone"
//    case Blur = "CIGaussianBlur"
////    case Tonal = "CIPhotoEffectTonal"
////    case Transfer = "CIPhotoEffectTransfer"
//}

class NewsTableViewController: UITableViewController {
    
    // MARK: - Private properties
    private var rssFeed: RSSFeed?
//    private var fetchingMore = false
//    private var items = [RSSFeedItem]()
//    private var paginagionCounter = 0
//    private var chunkedFeedItems: [[RSSFeedItem]]?
//    private var isLastItems = false
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
//        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCell")
        
        FeedLoader.shared.fetchFeed(from: StorageManager.shared.fetchChannel()) { rssFeed in
            self.rssFeed = rssFeed
            
//            if let feedItems = self.rssFeed?.items {
//                self.chunkedFeedItems = feedItems.chunked(by: 6)
//            }
            
//            guard let stringURL = rssFeed?.image?.url else { return }
//            guard let imageURL = URL(string: stringURL) else { return }
//            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            
            DispatchQueue.main.async {
//                let frame = CGRect(x: 0, y: 0, width: self.rssFeed?.image?.width ?? 0, height: self.rssFeed?.image?.height ?? 0)
//                let headerImageView = UIImageView(frame: frame)
//                headerImageView.contentMode = UIView.ContentMode.scaleAspectFit
//                headerImageView.image = UIImage(data: imageData) ?? UIImage(systemName: "pencil")
//                self.tableView.tableHeaderView = headerImageView
                
//                let logo = UIImage(named: "logo.png")
//                let imageView = UIImageView(image:logo)
//                self.navigationItem.titleView = headerImageView
                self.title = self.rssFeed?.title ?? "News"
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
        return self.rssFeed?.items?.count ?? 0
//        } else if section == 1 && fetchingMore {
//            return 1
//        }
//        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        if let item = self.rssFeed?.items?[indexPath.row] {
//            cell.configure(from: item)
        }
        
        return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
//            cell.activityIndicator.startAnimating()
//            return cell
//        }
//
    }
    
    
    
    // MARK: - UIScrollViewDelegate
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//
//        if (offsetY > contentHeight - scrollView.frame.height) && !fetchingMore {
//            loadMoreData()
//        }
//    }
    
    // MARK: - Private methods
//    private func loadMoreData() {
//
//        if !self.fetchingMore {
//            self.fetchingMore = true
//
//            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            
            /*
             Мы используем xml(все items прогружаются сразу)
             
             и не можем использовать параметры при запросах
             (в некоторых запросах можно указать количество загружаемых элементов)
             
             сделал пример имитирующий фоновую загрузку, чтобы показать ячейку с индикатором загрузки
             (тк использую массивы, данные прогружаются почти мнгновенно и не видно индикатора)
             */
//            DispatchQueue.global().async {
//                sleep(2)
//
//                if ((self.chunkedFeedItems?.count ?? 0) - 1) == self.paginagionCounter {
//
//                    if self.isLastItems {
//                        return
//                    } else {
//                        self.items += self.chunkedFeedItems?.last ?? []
//                        self.isLastItems = true
//                    }
//
//                } else {
//                    self.items += self.chunkedFeedItems?[self.paginagionCounter] ?? []
//                    self.paginagionCounter += 1
//                }
//
//                DispatchQueue.main.async {
//                    self.fetchingMore = false
//                    self.tableView.reloadData()
//
//                }
//            }
//        }
//    }
    
    @IBAction func editChannelAction(_ sender: Any) {
        
        let alertController = UIAlertController(
            title: "Add new rss source",
            message: "", preferredStyle: UIAlertController.Style.alert
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel", style: UIAlertAction.Style.cancel,
            handler: {(action : UIAlertAction!) -> Void in }
        )
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Resource Rss Link"
        }
        
        let saveAction = UIAlertAction(
            title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                
                let linkTextField = alertController.textFields![0] as UITextField
                
                if let urlSource = URL(string: linkTextField.text ?? "") {
//                    print("urlSource: \(urlSource)")
                    
                    if !UIApplication.shared.canOpenURL(urlSource) {
                        self.showAlert(with: "Provided URL is invalid.")
                        return
                    } else {
                        StorageManager.shared.saveChannel(url: urlSource)
                        
                        FeedLoader.shared.fetchFeed(from: StorageManager.shared.fetchChannel()) { rssFeed in
                            self.rssFeed = rssFeed
//                            print(StorageManager.shared.fetchChannel())
                            
                            DispatchQueue.main.async {
                                self.title = self.rssFeed?.title ?? "News"
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(with message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
//
//extension Collection {
//
//    func chunked(by distance: Int) -> [[Element]] {
//        precondition(distance > 0, "distance must be greater than 0")
//
//        var index = startIndex
//        let iterator: AnyIterator<Array<Element>> = AnyIterator({
//            let newIndex = self.index(index, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex
//            defer { index = newIndex }
//            let range = index ..< newIndex
//            return index != self.endIndex ? Array(self[range]) : nil
//        })
//
//        return Array(iterator)
//    }
//}


//extension UIImage {
//    func addFilter(filter : Filters) -> UIImage {
//        let filter = CIFilter(name: filter.rawValue)
//        // convert UIImage to CIImage and set as input
//        let ciInput = CIImage(image: self)
//        filter?.setValue(ciInput, forKey: "inputImage")
//        // get output CIImage, render as CGImage first to retain proper UIImage scale
//        let ciOutput = filter?.outputImage
//        let ciContext = CIContext()
//        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
//        //Return the image
//        return UIImage(cgImage: cgImage!)
//    }
//}
