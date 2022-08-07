//
//  MainViewModel.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

class MainViewModel: MainViewModelProtocol {
    var updateView: (() -> ())?
    var showError: ((ALError) -> ())?
    
    
    private var articles = [Article]() {
        didSet {
            updateView?()
        }
    }
    private var articlesRepository : ArticlesRepositoryProtocol
    
    init(articlesRepository: ArticlesRepositoryProtocol) {
        
        self.articlesRepository = articlesRepository
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectionRevieved), name: NSNotification.Name.init(rawValue: Constants.kNRMDidReceiveInternetConnectionNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    func saveArticles(format: DataFormat) {
        self.articlesRepository.saveArticles(articles: self.articles, format: format)
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
    
    @objc private func handleConnectionRevieved() {
        fetchArticles()
    }
}
