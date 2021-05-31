//
//  RSSFeedPhotoEditorPresenter.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 01.06.2021.
//

import Foundation

protocol RSSFeedPhotoEditorViewProtocol: class {
    func showFeeds()
    func showPaginationFeeds()
}

protocol RSSFeedPhotoEditorPresenterProtocol: class {
    init(view: RSSFeedPhotoEditorViewController)
    
    func loadFeed()
    func channelUpdate(url: URL)
    func setPagination()
    func loadMoreData()
    func setFilter(filter: Filters)
    func formatDate(date: Date)
    func useAsyncLoadAndSetFilterOperation()
    func cancelOperation()
}

class RSSFeedPhotoEditorPresenter: RSSFeedPhotoEditorPresenterProtocol {
    
    unowned private let view: RSSFeedPhotoEditorViewProtocol
    
    required init(view: RSSFeedPhotoEditorViewController) {
        self.view = view
    }
    
    func loadFeed() {
        <#code#>
    }
    
    func channelUpdate(url: URL) {
        <#code#>
    }
    
    func setPagination() {
        <#code#>
    }
    
    func loadMoreData() {
        <#code#>
    }
    
    func setFilter(filter: Filters) {
        <#code#>
    }
    
    func formatDate(date: Date) {
        <#code#>
    }
    
    func useAsyncLoadAndSetFilterOperation() {
        <#code#>
    }
    
    func cancelOperation() {
        <#code#>
    }
}
