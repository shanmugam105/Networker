//
//  Routes.swift
//  Network-Package-Example
//
//  Created by sparkout on 07/03/24.
//

import Networker

let apiMode: APIMode = .development

extension APIMode {
    var baseUrl: String {
        switch self {
        case .staging:
            return "Your staging url"
        case .production:
            return "Your production url"
        case .development:
            return "https://jsonplaceholder.typicode.com/"
        }
    }
}


enum Routes: RouteProtocol {
    case getBlog(Int)
    
    var urlPath: String {
        switch self {
        case .getBlog:
            return apiMode.baseUrl + path
        }
    }
    
    var path: String {
        switch self {
        case .getBlog(let id):
            return "todos/\(id)"
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .getBlog:
            return ["Content-Type": "application/json"]
        }
    }
    
    var httpMethod: Networker.HTTPMethod {
        switch self {
        case .getBlog:
            return .GET
        }
    }
}
