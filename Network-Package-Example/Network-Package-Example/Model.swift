//
//  Model.swift
//  Network-Package-Example
//
//  Created by sparkout on 07/03/24.
//

import Foundation

// MARK: - BlogTitle
struct BlogTitle: Codable {
    let userID, id: Int?
    let title: String?
    let completed: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
