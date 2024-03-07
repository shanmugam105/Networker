//
//  LocalError.swift
//
//

import Foundation

enum LocalError: LocalizedError {
    case unknownError(_ message: String?)
    // Input Error
    case phoneCantBeEmpty
    case invalidPhone
    // API Errors
    case decodingError
    case badRequest
    case serverError
    case parsingError
    case unAuthorized
    
    var description: String {
        switch self {
        case .unknownError(let message):
            if let message, !message.isEmpty {
                return message
            }
            return "Unknown Error!"
        case .serverError: return "Server Error!"
        case .parsingError: return "Unable to parse the response"
        case .unAuthorized: return "Unauthorized request!"
        case .phoneCantBeEmpty: return "Please enter phone number"
        case .invalidPhone: return "Please enter valid phone number"
        case .decodingError: return "Decoding Error!"
        case .badRequest: return "Bad Request!"
        }
    }
}

extension LocalError: Equatable {
    static func == (lhs: LocalError, rhs: LocalError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}
