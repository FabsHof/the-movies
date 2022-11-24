//
//  Errors.swift
//  The Movies
//
//  Created by Fabian Hofmann on 04.11.22.
//

import Foundation
///
/// Custom HTTP-error to handle special cases for this application.
///
enum HttpError: Error {
    case invalidUrl
    case unauthorized
}

///
/// Value representations of the custom errors.
///
extension HttpError: CustomStringConvertible {
    public var description: String {
        switch self {
            case .invalidUrl:
                return "The provided URL is invalid!"
            case .unauthorized:
                return "The API key is invalid!"
        }
    }
}
