//
//  RSSFeedPhotoEditorViewControllerExtensions.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 01.06.2021.
//

import UIKit

// MARK: - UITableViewDataSource
extension RSSFeedPhotoEditorViewController: UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PublicationCell
            
            let items = self.visibleFeedItems[indexPath.row]
            let itemUrl = self.visibleFeedItems[indexPath.row].enclosure?.attributes?.url
            let defaultImage = #imageLiteral(resourceName: "rss2")
            
            cell.itemPubDateLabel.text = formatDate(date: items.pubDate)
            cell.itemTitleLable.text = items.title
            
            if let urlString = itemUrl, let url = URL(string: urlString) {
                if filterSwitch.isOn {
                    // Using Operation instead
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
extension RSSFeedPhotoEditorViewController: UITableViewDelegate {
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
extension RSSFeedPhotoEditorViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
    }
}

// MARK: - AlertController
extension RSSFeedPhotoEditorViewController {
    internal func newSourceAlert () {
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
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
