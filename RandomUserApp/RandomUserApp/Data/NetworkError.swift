//
//  Untitled.swift
//  RandomUserApp
//
//  Created by walid on 28/3/2025.
//
import Foundation

enum NetworkError: Error, Equatable {
    case badURL
    case requestFailed
    case decodingError
    case noData
    case serverError(statusCode: Int)
    case unauthorized
    case forbidden
    case notFound
    case internalServerError
    case unknownError
}

extension NetworkError {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badURL, .badURL),
             (.unauthorized, .unauthorized),
             (.forbidden, .forbidden),
             (.notFound, .notFound),
             (.internalServerError, .internalServerError),
             (.unknownError, .unknownError):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
}
