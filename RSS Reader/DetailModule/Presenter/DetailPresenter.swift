//
//  DetailPresenter.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 14.06.2021.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    func setComment(comment: Comment?)
}

protocol DetailViewPresenterProtocol: AnyObject {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, comment: Comment?)
    
    func setComment()
}

class DetailPresenter: DetailViewPresenterProtocol {
    weak var view: DetailViewProtocol?
    let networkService: NetworkServiceProtocol!
    var comment: Comment?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, comment: Comment?) {
        self.view = view
        self.networkService = networkService
        self.comment = comment
    }
    
    func setComment() {
        self.view?.setComment(comment: comment)
    }
}
