//
//  NewsViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import UIKit
import FeedKit
import Kingfisher

class RSSFeedPhotoEditorViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet var filterButtons: [UIButton]!
    
    // MARK: - internal properties
    internal let queue = OperationQueue()
    internal var operations: [IndexPath: [Operation]] = [:]
    
    internal var rssFeed: RSSFeed?
    internal var visibleFeedItems = [RSSFeedItem]()
    
    internal var isLoading = false
    
    internal var imageFilter = "CIPhotoEffectFade"
    
    // MARK: - private properties
    private var paginagionCounter = 0
    
    private var paginationItems: [[RSSFeedItem]]?
    
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
    
    // MARK: - IB Actions
    @IBAction func editChannelPressed(_ sender: Any) {
        newSourceAlert()
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
    
    private func filterButtonsState() {
        filterButtons.forEach { button in
            button.isEnabled = filterSwitch.isOn
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - internal methods
    internal func channelUpdate(url: URL) {
        self.rssFeed = RSSFeed()
        self.paginationItems?.removeAll()
        self.visibleFeedItems.removeAll()
        self.paginagionCounter = 0
        self.isLoading = false
        
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
    
    internal func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            
            // Fake loading new items
            DispatchQueue.global().async {
                sleep(2)
                if ((self.paginationItems?.count ?? 0) - 1) == self.paginagionCounter {
                    self.visibleFeedItems += self.paginationItems?.last ?? []
                    return
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
    
    internal func formatDate(date: Date?) -> String {
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
            
            let feedItemVC = segue.destination as! DetailPublicationViewController
            feedItemVC.selectedFeedURL = url
        }
    }
}
