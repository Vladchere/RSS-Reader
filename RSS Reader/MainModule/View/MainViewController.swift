//
//  NewsViewController.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import UIKit
import FeedKit
import Kingfisher

class MainViewController: UIViewController {

    var presenter: MainViewPresenterProtocol!
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var feed: UILabel!

    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IB Actions
    @IBAction func didTapButton(_ sender: Any) {
        self.presenter.showFeed()
    }
}


extension MainViewController: MainViewProtocol {
    func setFeed(from url: String) {
        self.feed.text = url
    }
}
