//
//  NetworkError.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation
enum NetworkError: LocalizedError {
    
    case http(statusCode: Int)
    case network(error: Error?)
    case parsing(error: Error)
    case custom(descriptions: [String])
    case data
    case unknown
    
    var isHttp: Bool {
        switch self {
        case .http:
            return true
        default:
            return false
        }
    }
    
    var isNetwork: Bool {
        switch self {
        case .network:
            return true
        default:
            return false
        }
    }
    
    var isParsing: Bool {
        switch self {
        case .parsing:
            return true
        default:
            return false
        }
    }
    
    var isCustom: Bool {
        switch self {
        case .custom:
            return true
        default:
            return false
        }
    }
    
    var isData: Bool {
        switch self {
        case .data:
            return true
        default:
            return false
        }
    }
    
    var isUnknown: Bool {
        switch self {
        case .unknown:
            return true
        default:
            return false
        }
    }
}
