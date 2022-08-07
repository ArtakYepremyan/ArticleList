//
//  ArticlesRepositoryProtocol.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

protocol ArticlesRepositoryProtocol {
    
    typealias CompletionHandlerResult = Result<[Article], ALError>
    typealias CompletionHandler = ((CompletionHandlerResult) -> ())

    func getArticles(completionHandler: @escaping CompletionHandler)
    func saveArticles(articles: [Article], format: DataFormat)
}
