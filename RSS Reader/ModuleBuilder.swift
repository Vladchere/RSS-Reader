//
//  ModuleBuilder.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 03.06.2021.
//

import UIKit


protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModuleBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let model = Feed(url: "https://lenta.ru/rss/articles")
        let view = MainViewController()
        let presenter = MainPresenter(view: view, feed: model)
        
        view.presenter = presenter
        
        return view
    }
}
