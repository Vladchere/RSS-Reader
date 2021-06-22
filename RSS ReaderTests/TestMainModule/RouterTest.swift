//
//  RouterTest.swift
//  RSS ReaderTests
//
//  Created by Vladislav Cheremisov on 17.06.2021.
//

import XCTest
@testable import RSS_Reader

class MockNavigationController: UINavigationController {
    var presenterVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.presenterVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navigationController = MockNavigationController()
    let assembly = AssemblyModuleBuilder()

    override func setUpWithError() throws {
        router = Router(navigationController: navigationController, assemblyBuilder: assembly)
    }

    override func tearDownWithError() throws {
        router = nil
    }
    
    func testRouter() {
        router.showDetail(comment: nil)
        let detailViewController = navigationController.presenterVC
        
        XCTAssertTrue(detailViewController is DetailViewController)
    }
}
