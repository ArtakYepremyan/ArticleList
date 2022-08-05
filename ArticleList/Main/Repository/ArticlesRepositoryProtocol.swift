//
//  ArticlesRepositoryProtocol.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

protocol ArticlesRepositoryProtocol {
    
    typealias CompletionHandlerResult = Result<[Article], NetworkError>
    typealias CompletionHandler = ((CompletionHandlerResult) -> ())
    typealias SavingCompletionHandler = (Bool) -> ()

    func getArticles(completionHandler: @escaping CompletionHandler)
    func saveArticles(articles: [Article], completion: SavingCompletionHandler)
}
