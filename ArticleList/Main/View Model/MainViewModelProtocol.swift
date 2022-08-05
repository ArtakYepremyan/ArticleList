//
//  MainViewModelProtocol.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import Foundation

protocol MainViewModelProtocol {
    
    var updateView: (() -> ())? {get set}
    var showError: ((NetworkError) -> ())? {get set}
    func numberOfRows() -> Int
    func itemForRow(row: Int) -> Article
    func viewIsReady()
}

