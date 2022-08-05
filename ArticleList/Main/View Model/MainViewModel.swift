//
//  MainViewModel.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

class MainViewModel: MainViewModelProtocol {
    var updateView: (() -> ())?
    var showError: ((NetworkError) -> ())?
    
    
    private var articles = [Article]()
    private var articlesRepository : ArticlesRepositoryProtocol
    
    init(articlesRepository: ArticlesRepositoryProtocol) {
        
        self.articlesRepository = articlesRepository
    }
  
    
    func numberOfRows() -> Int {
        articles.count
    }
    
    func itemForRow(row: Int) -> Article {
        articles[row]
    }
    
    func viewIsReady() {
        fetchArticles()
    }
    
    private func fetchArticles() {
        articlesRepository.getArticles { result in
            switch result {
            case .failure(let error):
                self.showError?(error)
            case.success(let arts):
                self.articles = arts.sorted {$0.publishedDate > $1.publishedDate}
                break
            }
        }
    }    
}
