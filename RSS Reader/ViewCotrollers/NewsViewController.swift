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
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet var filterButtons: [UIButton]!
    
    // MARK: - Private properties
    private let queue = OperationQueue()
    private var operations: [IndexPath: [Operation]] = [:]
    
    private var imageFilter = "CIPhotoEffectFade"
    
    private var rssFeed: RSSFeed?
    
    private var visibleFeedItems = [RSSFeedItem]()
    
    private var paginagionCounter = 0
    private var paginationItems: [[RSSFeedItem]]?
    
    private var isLoading = false
    private var isLastItem = false
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Register Loading Cell
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCell")
        
        loadFeed()
        filterButtonsState()
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
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { alert -> Void in
                let linkTextField = alertController.textFields![0] as UITextField
                if let urlSource = URL(string: linkTextField.text ?? "") {
                    if !UIApplication.shared.canOpenURL(urlSource) {
                        self.showAlert(with: "Provided URL is invalid.")
                        return
                    } else {
                        self.channelUpdate(url: urlSource)
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
        case 1:
            self.imageFilter = Filters.Mono.rawValue
        case 2:
            self.imageFilter = Filters.Sepia.rawValue
        case 3:
            self.imageFilter = Filters.Blur.rawValue
        case 4:
            self.imageFilter = Filters.Chrome.rawValue
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        filterButtonsState()
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
                self.paginationItems = feedItems.chunked(by: 6)
            }
            
            DispatchQueue.main.async {
                self.title = self.rssFeed?.title ?? "News"
                self.tableView.reloadData()
            }
        }
    }
    
    private func channelUpdate(url: URL) {
        
        self.operations = [:]
        self.imageFilter = "CIPhotoEffectFade"
        self.rssFeed = RSSFeed()
        self.visibleFeedItems = []
        self.paginagionCounter = 0
        self.paginationItems = [[]]
        self.isLoading = false
        self.isLastItem = false
        
        StorageManager.shared.saveChannel(url: url)
        
        FeedLoader.shared.fetchFeed(from: url) { rssFeed in
            self.rssFeed = rssFeed
            
            if let feedItems = self.rssFeed?.items {
                self.paginationItems = feedItems.chunked(by: 6)
                self.loadMoreData()
            }
            
            DispatchQueue.main.async {
                self.title = self.rssFeed?.title ?? "News"
                self.tableView.reloadData()
            }
        }
    }
    
    private func loadMoreData() {
        
        if !self.isLoading {
            
            self.isLoading = true
            
            DispatchQueue.global().async {
                sleep(1)
                if ((self.paginationItems?.count ?? 0) - 1) == self.paginagionCounter {
                    
                    if self.isLastItem {
                        return
                    } else {
                        self.visibleFeedItems += self.paginationItems?.last ?? []
                        self.isLastItem = true
                    }
                    
                } else {
                    self.visibleFeedItems += self.paginationItems?[self.paginagionCounter] ?? []
                    self.paginagionCounter += 1
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
    private func filterButtonsState() {
        if filterSwitch.isOn {
            filterButtons.forEach { button in
                button.isEnabled = true
            }
        } else {
            filterButtons.forEach { button in
                button.isEnabled = false
            }
        }
    }
    
    private func format(date: Date?) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.YY"
        
        if let date = date {
            return formatter.string(from: date)
        } else {
            return "No publication date"
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let url = self.visibleFeedItems[indexPath.row].guid?.value
            
            let feedItemVC = segue.destination as! FeedItemWebViewController
            feedItemVC.selectedFeedURL = url
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
            return self.visibleFeedItems.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            
            let items = self.visibleFeedItems[indexPath.row]
            let itemUrl = self.visibleFeedItems[indexPath.row].enclosure?.attributes?.url
            let defaultImage = #imageLiteral(resourceName: "rss2")

            cell.itemPubDateLabel.text = format(date: items.pubDate)
            cell.itemTitleLable.text = items.title
            
            if let urlString = itemUrl, let url = URL(string: urlString) {
                
                if filterSwitch.isOn {
                    
                    let downloadOpt = DownloadImageOperation(url: url)
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
                } else {
                    
                    cell.newsImageView.kf.setImage(with: url)
                }
                
                return cell
            } else {
                cell.newsImageView.image = defaultImage
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
            
            if self.visibleFeedItems.count == self.rssFeed?.items?.count {
                cell.isHidden = true
            } else {
                cell.activityIndicator.startAnimating()
            }
            
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
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
    }
}














