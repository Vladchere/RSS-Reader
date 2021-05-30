////
////  ImageView.swift
////  RSS Reader
////
////  Created by Vladislav Cheremisov on 29.05.2021.
////
//
//import UIKit
//
//
//class ImageView: UIImageView {
//
//    func fetchImage (from url: String) {
//        
//        image = nil
//
//        guard let url = URL(string: url) else {
//            image = UIImage(systemName: "pencil.and.outline")
//            return
//        }
//
//        // Если изображение есть в кеше, то используем его
//        if let cachedImage = getCachedImage(url: url) {
//            print("cachedImage")
//            image = cachedImage
//            return
//        }
//
//        // Если изображения нет, то грузим из сети
//        func getImage (from url: URL, completion: @escaping (Data, URLResponse) -> Void) {
//            print("getImage")
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let error = error { print(error.localizedDescription); return }
//                guard let data = data else { return }
//                guard let response = response else { return }
//                guard let responseUrl = response.url else { return }
//                guard responseUrl == url else { return }
//                completion(data, response)
//            }.resume()
//        }
//
//        getImage(from: url) { (data, response) in
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data)
//            }
//
//            // Сохраняем изображение в кеш
//            self.saveDataToCach(with: data, and: response)
//        }
//    }
//
//    private func getCachedImage(url: URL) -> UIImage? {
//        let urlRequest = URLRequest(url: url)
//        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
//            return UIImage(data: cachedResponse.data)
//        }
//        return nil
//    }
//
//    private func saveDataToCach(with data: Data, and response: URLResponse) {
//        guard let urlResponse = response.url else { return }
//        let cachedResponse = CachedURLResponse(response: response, data: data)
//        let urlRequest = URLRequest(url: urlResponse)
//        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
//    }
//}
