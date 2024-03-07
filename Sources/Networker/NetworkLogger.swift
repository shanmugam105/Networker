//
//  URLSessionProvider.swift
//  Webservice
//
//

import Foundation

open class NetworkLogger {
    public class func log(request: URLRequest) {

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod ?? "GET"
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody {
            let bodyString = body.prettyPrintedJSONString ?? String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded"
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n"
        print(requestLog)
    }

    public class func log(data: Data?, response: URLResponse?) {

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

        if let httpResponse = response as? HTTPURLResponse {
            responseLog += "HTTP \(httpResponse.statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        for (key, value) in (response as? HTTPURLResponse)?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data {
            let bodyString = body.prettyPrintedJSONString ?? String(data: body, encoding: .utf8) ?? "Can't render body; not utf8 encoded"
            responseLog += "\n\(bodyString)\n"
        }

        responseLog += "<------------------------\n"
        #if DEBUG
        print(responseLog)
        #endif
    }
    
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: .utf8)
            else {
                return nil
        }

        return prettyPrintedString
    }
}
