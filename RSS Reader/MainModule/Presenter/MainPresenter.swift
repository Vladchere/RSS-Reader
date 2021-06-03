//
//  MainPresenter.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 03.06.2021.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    func setFeed(from url: String)
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, feed: Feed)
    func showFeed()
}

class MainPresenter: MainViewPresenterProtocol {
    let view: MainViewProtocol
    let feed: Feed
    
    required init(view: MainViewProtocol, feed: Feed) {
        self.view = view
        self.feed = feed
    }
    
    func showFeed() {
        let url = "https://lenta.ru/rss/articles"
        self.view.setFeed(from: url)
    }
}
