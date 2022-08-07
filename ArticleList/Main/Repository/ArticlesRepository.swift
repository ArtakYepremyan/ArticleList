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
    let localDataSource: ArticlesLocalDataSourceProtocol

    
    init(firstDataSource: ArticlesDataSourceProtocol, secondDataSource:  ArticlesDataSourceProtocol, localDataSource: ArticlesLocalDataSourceProtocol) {
        self.firstDataSource = firstDataSource
        self.secondDataSource = secondDataSource
        self.localDataSource = localDataSource
    }
    
    func getArticles(completionHandler: @escaping CompletionHandler) {
        
        guard NetworkConnectionManager.shared.isReachable == true  else {
            localDataSource.get(completionHandler: completionHandler)
            return
        }
        
        var articles = [Article]()
        var errors = [ALError]()
        
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
    
    func saveArticles(articles: [Article], format: DataFormat) {
        localDataSource.save(items: articles, format: format)
    }
}
