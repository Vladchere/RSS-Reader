//
//  NewsViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import UIKit
import FeedKit

class NewsViewController: UIViewController {
    
    private let queue = OperationQueue()
    private var operations: [IndexPath: [Operation]] = [:]
    var imageFilter = "CIPhotoEffectFade"
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private properties
    private var rssFeed: RSSFeed?
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
            
            DispatchQueue.main.async {
                self.title = self.rssFeed?.title ?? "News"
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssFeed?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        let input = self.rssFeed?.items?[indexPath.row].enclosure?.attributes?.url ?? ""
        
        let downloadOpt = DownloadImageOperation(url: URL(string: input)!)
        let imageFilter = ImageFilterOperation()
        imageFilter.filter = self.imageFilter
        
        imageFilter.addDependency(downloadOpt)
        imageFilter.completionBlock = {
            DispatchQueue.main.async {
                cell.itemTitleLable.text = self.rssFeed?.items?[indexPath.row].title
                
                let pubDate = self.rssFeed?.items?[indexPath.row].pubDate
                cell.itemPubDateLabel.text = DateFormater.shared.format(date: pubDate)
                
                cell.newsImageView.image = imageFilter.processedImage
            }
        }
        
        self.queue.addOperation(downloadOpt)
        self.queue.addOperation(imageFilter)
        
        if let existingOperations = operations[indexPath] {
            for operation in existingOperations {
                operation.cancel()
            }
        }
        operations[indexPath] = [imageFilter, downloadOpt]
        
        return cell
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
}
















/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
