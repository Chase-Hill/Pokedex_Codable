//
//  ResultError.swift
//  Pokedex_Codable
//
//  Created by Karl Pfister on 2/7/22.
//

import Foundation

enum ResultError: LocalizedError {
    
    case invalidURL
    case thrownError(Error)
    case noData
    case unableToDecode
    case noUser
    
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server. Please try again."
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .noData:
            return "The server responded with no data. Please try again."
        case .unableToDecode:
            return "The server responded with bad data. Please try again."
        case .noUser:
            return "Do you need to sign in?"
        }
    }
}
