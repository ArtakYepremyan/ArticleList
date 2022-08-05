//
//  ArticlesRepository.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation


struct ArticlesRepository: ArticlesRepositoryProtocol {
    
    let firstDataSource: ArticlesDataSourceProtocol
    let secondDataSource: ArticlesDataSourceProtocol

    
    init(firstDataSource: ArticlesDataSourceProtocol, secondDataSource:  ArticlesDataSourceProtocol) {
        self.firstDataSource = firstDataSource
        self.secondDataSource = secondDataSource
    }
    
    func getArticles(completionHandler: @escaping CompletionHandler) {
        
        var articles = [Article]()
        var errors = [NetworkError]()
        
        //here I use semaphore because two different tasks must use same shared resource
        let semaphore = DispatchSemaphore(value: 0)
        
        firstDataSource.get { result in
            switch result {
                
            case .success(let arts):
                articles += arts
            case .failure(let error):
                errors.append(error)
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        secondDataSource.get { result in
            switch result {
                
            case .success(let arts):
                articles += arts
            case .failure(let error):
                errors.append(error)
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        if errors.isEmpty {
            completionHandler(.success(articles))
        } else {
            print(errors)
            completionHandler(.failure(errors.first!))
        }
    }
    
    func saveArticles(articles: [Article], completion: (Bool) -> ()) {
        
    }
}
