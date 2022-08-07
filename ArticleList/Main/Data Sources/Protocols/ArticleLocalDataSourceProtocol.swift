//
//  ArticleLocalDataSourceProtocol.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 07.08.22.
//

import Foundation

protocol ArticlesLocalDataSourceProtocol: ArticlesDataSourceProtocol {
    
    func save(items: [Article], format: DataFormat)
}

enum DataFormat {
    case xml
    case json
}
