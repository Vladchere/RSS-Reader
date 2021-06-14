//
//  ModuleBuilder.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 14.06.2021.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModelBuilder: Builder {
    static func createMainModule() -> UIViewController {
        let model = Person(firstName: "David", lastName: "Blaine")
        let view = MainViewController()
        let presenter = MainPresenter(view: view, person: model)
        
        view.presenter = presenter
        return view
    }
}
