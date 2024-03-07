//
//  Route.swift
//  Network-Call-Practice
//
//  Created by ADMIN on 19/06/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import Foundation

public protocol RouteProtocol {
    var urlPath: String { get }
    var path: String { get }
    var header: [String: String]? { get }
    var httpMethod: HTTPMethod { get }
}
