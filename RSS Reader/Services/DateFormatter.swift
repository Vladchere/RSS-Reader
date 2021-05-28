//
//  DateFormatter.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 29.05.2021.
//

import Foundation

class DateFormater {
    
    static let shared = DateFormater()
    private init() {}
    
    func format(date: Date?) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.YY"
        
        if let date = date {
            return formatter.string(from: date)
        } else {
            return "No publication date"
        }
    }
}
