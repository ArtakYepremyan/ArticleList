//
//  ArticlesDefaultDataSource.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

struct ArticlesDefaultDataSource: ArticlesDataSourceProtocol {
    
    func get(completionHandler: @escaping CompletionHandler) {
        
        let request = URLRequest(url: URLs.articlesUrl)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse else {
                    completionHandler(.failure(.network(error: error)))
                    return
                }
                
                switch response.statusCode {
                case 200:
                    completionHandler(handleStatusCode200(with: data))
                case 400...500:
                    completionHandler(.failure(.http(statusCode: response.statusCode)))
                default:
                    completionHandler(.failure(.unknown))
                }
        }
        task.resume()
    }
    
    private func handleStatusCode200(with data: Data) -> CompletionHandlerResult {
        do {
            let result = try JSONDecoder().decode(ArticlesResponseBody.self, from: data)
            return .success(result.articles)
        } catch {
            return .failure(.parsing(error: error))
        }
    }
}
