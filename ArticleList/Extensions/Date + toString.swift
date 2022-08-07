//
//  Date + toString.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 07.08.22.
//

import Foundation

extension Date {
    
    func toStringLongFormat() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func toStringShortFormat() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

