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

    // MARK: - IB Outlets
    @IBOutlet weak var feed: UILabel!
    
    var presenter: MainViewPresenterProtocol!
    

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
