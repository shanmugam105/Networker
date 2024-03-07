//
//  NetworkService.swift
//  Network-Call-Practice
//
//  Created by ADMIN on 19/06/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import Combine
import Foundation

public typealias Completion = () -> Void
public typealias CompletionValue<T> = (T) -> Void
public typealias CompletionWithLocalError = (LocalError?) -> Void
public typealias CompletionWithResult<T> = (Swift.Result<T, LocalError>) -> Void

public final class NetworkService {
    var defaultParams: [String: Any]
    
    public static let shared = NetworkService()
    
    private init() {
        self.defaultParams = [:]
    }
    
    private init(params: [String: Any]) {
        self.defaultParams = params
    }
    
    public func request<T: Codable>(route: RouteProtocol,
                             parameter: [String: Any]? = nil,
                             formData: MultipartForm? = nil,
                             type: T.Type) -> AnyPublisher<T, LocalError> {
        defaultParams.append(anotherDict: parameter)
        let request = createRequest(route: route, parameter: defaultParams, formData: formData)
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { (data, response) -> Data in
                #if DEBUG
                NetworkLogger.log(request: request)
                NetworkLogger.log(data: data, response: response)
                #endif
                return data
            }
            .decode(type: type, decoder: JSONDecoder())
            .mapError { error -> LocalError in
                print(error)
                return LocalError.unknownError(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// This function helps to create URLRequest
    /// - Parameters:
    ///   - route: Backend resource path
    ///   - method: Type of HTTP Request
    ///   - parameter: Need to pass to backend
    /// - Returns: It returns URLRequest
    private func createRequest(route: RouteProtocol,
                               parameter: [String: Any],
                               formData: MultipartForm? = nil) -> URLRequest {
        let url = URL(string: route.urlPath)!
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        route.header?.forEach { header in
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
        urlRequest.httpMethod = route.httpMethod.rawValue
        let params = parameter
        switch route.httpMethod {
        case .GET:
            var urlComponent = URLComponents(string: route.urlPath)
            urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)") }
            urlRequest.url = urlComponent?.url
        case .POST, .PATCH:
            let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            urlRequest.httpBody = bodyData
            
        case .DELETE:
            let bodyData = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = bodyData
        }
        
        if let formData {
            urlRequest.httpMethod = HTTPMethod.POST.rawValue
            urlRequest.setValue(formData.contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = formData.bodyData
        }
        return urlRequest
    }
}

extension Dictionary where Key == String, Value == Any {
    
    mutating func append(anotherDict: [String:Any]?) {
        if let anotherDict {
            for (key, value) in anotherDict {
                self.updateValue(value, forKey: key)
            }
        }
    }
}
