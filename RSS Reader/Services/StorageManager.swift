//
//  StorageManager.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 30.05.2021.
//

import Foundation

class StorageManager {
    
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let channelKey = "channel"
    
    func saveChannel(url: URL) {
        guard let data = try? JSONEncoder().encode(url) else { return }
        userDefaults.set(data, forKey: channelKey)
    }
    
    func fetchChannel() -> URL {
        let defaultChannel = URL(string: "https://lenta.ru/rss/articles")!
        guard let data = userDefaults.object(forKey: channelKey) as? Data else { return defaultChannel }
        guard let channel = try? JSONDecoder().decode(URL.self, from: data) else { return defaultChannel }
        
        return channel
    }
}
