//
//  ArticlesFeedDataSource.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

struct ArticlesFeedDataSource: ArticlesDataSourceProtocol {
    
    let parser = ArticleFeedParser()
    
    func get(completionHandler: @escaping CompletionHandler) {
        
        let request = URLRequest(url: URLs.articlesFeedUrl)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.network(error: error)))
                return
            }
            
            switch response.statusCode {
            case 200:
                handleStatusCode200(with: data) { result in
                    completionHandler(result)
                }
            case 400...500:
                completionHandler(.failure(.http(statusCode: response.statusCode)))
            default:
                completionHandler(.failure(.unknown))
            }
        }
        task.resume()
    }
    
    private func handleStatusCode200(with data: Data, completionHandler: @escaping CompletionHandler) {
        parser.parseFeed(data: data) { result in
            completionHandler(result)
        }
    }
}

