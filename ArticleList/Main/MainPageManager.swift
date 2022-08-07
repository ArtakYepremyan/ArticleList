//
//  MainPageManager.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 07.08.22.
//

import Foundation
import UIKit

class MainPageManager {
    
    static func createMainPageViewController() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let articlesFeedDataSource = ArticlesFeedDataSource()
        let articlesDefaultDataSource = ArticlesDefaultDataSource()
        let localDataSource = ArticlesLocalDataSource()
        let repository = ArticlesRepository(firstDataSource: articlesFeedDataSource, secondDataSource: articlesDefaultDataSource, localDataSource: localDataSource)
        let viewModel = MainViewModel(articlesRepository: repository)
        vc.viewModel = viewModel
        return vc
    }
}
