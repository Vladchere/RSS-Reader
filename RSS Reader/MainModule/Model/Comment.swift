//
//  Person.swift
//  RSS Reader
//
//  Created by Vladislav Cheremisov on 09.06.2021.
//

import Foundation

struct Comment: Decodable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
