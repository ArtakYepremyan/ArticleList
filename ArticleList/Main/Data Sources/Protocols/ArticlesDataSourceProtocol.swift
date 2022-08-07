//
//  ArticlesDataSourceProtocol.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation
protocol ArticlesDataSourceProtocol {
    
    typealias CompletionHandlerResult = Result<[Article], ALError>
    typealias CompletionHandler = ((CompletionHandlerResult) -> ())
    
    func get(completionHandler: @escaping CompletionHandler)
}
