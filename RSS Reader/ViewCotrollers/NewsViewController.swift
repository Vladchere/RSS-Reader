//
//  NewsViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import UIKit
import FeedKit
import Kingfisher

class NewsViewController: UIViewController {
    
    private let queue = OperationQueue()
    private var operations: [IndexPath: [Operation]] = [:]
    
    var imageFilter = "CIPhotoEffectFade"
    
    private var fetchingMore = false
    private var items = [RSSFeedItem]()
    private var paginagionCounter = 0
    private var chunkedFeedItems: [[RSSFeedItem]]?
    private var isLastItems = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    private var rssFeed: RSSFeed?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCell")
        
        loadFeed()
    }
    
    // MARK: - IBActions
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
                    
                    if !UIApplication.shared.canOpenURL(urlSource) {
                        self.showAlert(with: "Provided URL is invalid.")
                        return
                    } else {
                        StorageManager.shared.saveChannel(url: urlSource)
                        
                        self.loadFeed()
                    }
                }
            })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.imageFilter = Filters.Fade.rawValue
            print("fade")
        case 1:
            self.imageFilter = Filters.Mono.rawValue
            print("mono")
        case 2:
            self.imageFilter = Filters.Sepia.rawValue
            print("sepia")
        case 3:
            self.imageFilter = Filters.Blur.rawValue
            print("blur")
        case 4:
            self.imageFilter = Filters.Chrome.rawValue
            print("chrom")
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Private methods
    private func showAlert(with message:String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadFeed() {
        let url = StorageManager.shared.fetchChannel()
        
        FeedLoader.shared.fetchFeed(from: url) { rssFeed in
            self.rssFeed = rssFeed
            
            if let feedItems = self.rssFeed?.items {
                self.chunkedFeedItems = feedItems.chunked(by: 6)
            }
            
            DispatchQueue.main.async {
                self.title = self.rssFeed?.title ?? "News"
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadMoreData() {
        
        if !self.fetchingMore {
            self.fetchingMore = true
            
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            
            /*
             Мы используем xml(все items прогружаются сразу)
             
             и не можем использовать параметры при запросах
             (в некоторых запросах можно указать количество загружаемых элементов)
             
             сделал пример имитирующий фоновую загрузку, чтобы показать ячейку с индикатором загрузки
             (тк использую массивы, данные прогружаются почти мнгновенно и не видно индикатора)
             */
            DispatchQueue.global().async {
                sleep(2)
                
                if ((self.chunkedFeedItems?.count ?? 0) - 1) == self.paginagionCounter {
                    
                    if self.isLastItems {
                        return
                    } else {
                        self.items += self.chunkedFeedItems?.last ?? []
                        self.isLastItems = true
                    }
                    
                } else {
                    self.items += self.chunkedFeedItems?[self.paginagionCounter] ?? []
                    self.paginagionCounter += 1
                }
                
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.tableView.reloadData()
                }
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.rssFeed?.items?.count ?? 0
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            
            let items = self.rssFeed?.items?[indexPath.row]
            let itemUrl = (self.rssFeed?.items?[indexPath.row].enclosure?.attributes?.url)!
            //        let titleUrl = self.rssFeed?.image?.url
            
            cell.itemTitleLable.text = items?.title
            
            let pubDate = items?.pubDate
            cell.itemPubDateLabel.text = cell.format(date: pubDate)
            
            
            
            // Using Operation instead
            let downloadOpt = DownloadImageOperation(url: URL(string: itemUrl)!)
            let setFilter = ImageFilterOperation()
            
            setFilter.imageFilter = self.imageFilter
            
            setFilter.addDependency(downloadOpt)
            setFilter.completionBlock = {
                DispatchQueue.main.async {
                    cell.newsImageView.image = setFilter.processedImage
                }
            }
            self.queue.addOperation(downloadOpt)
            self.queue.addOperation(setFilter)
            
            if let existingOperations = operations[indexPath] {
                for operation in existingOperations {
                    operation.cancel()
                }
            }
            operations[indexPath] = [setFilter, downloadOpt]
            
            cell.newsImageView.kf.setImage(with: URL(string: itemUrl)!)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
}


// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 130
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operations = operations[indexPath] {
            for operation in operations {
                operation.cancel()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension NewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height) && !fetchingMore {
            loadMoreData()
        }
    }
}



extension Collection {
    
    func chunked(by distance: Int) -> [[Element]] {
        precondition(distance > 0, "distance must be greater than 0")
        
        var index = startIndex
        let iterator: AnyIterator<Array<Element>> = AnyIterator({
            let newIndex = self.index(index, offsetBy: distance, limitedBy: self.endIndex) ?? self.endIndex
            defer { index = newIndex }
            let range = index ..< newIndex
            return index != self.endIndex ? Array(self[range]) : nil
        })
        
        return Array(iterator)
    }
}










/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
