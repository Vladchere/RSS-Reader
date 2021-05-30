//
//  DownloadImageOperator.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import Foundation
import UIKit

class DownloadImageOperation: AsyncOperation {
    let url: URL
    var outputImage: UIImage?
    private var task: URLSessionDataTask?

    init(url: URL) {
        self.url = url
    }

    override func main() {
        self.task = URLSession.shared.dataTask(with: self.url, completionHandler: { [weak self] (data, res, error) in
            guard let `self` = self else { return }

            defer { self.state = .finished }

            guard !self.isCancelled else { return }

            guard error == nil,
                let data = data else { return }

            self.outputImage = UIImage(data: data)
        })
        task?.resume()
    }

    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}


class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        
        var keyPath: String {
            return "is\(rawValue.capitalized)"
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }

    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
            
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
}
