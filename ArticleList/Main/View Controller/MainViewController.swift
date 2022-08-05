//
//  MainViewController.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupBindings()
    }

    
    private func setupViewModel() {
        let articlesFeedDataSource = ArticlesFeedDataSource()
        let articlesDefaultDataSource = ArticlesDefaultDataSource()
        let repository = ArticlesRepository(firstDataSource: articlesFeedDataSource, secondDataSource: articlesDefaultDataSource)
        viewModel = MainViewModel(articlesRepository: repository)
    }
    
    private func setupBindings() {
        viewModel.showError = { error in
            self.showError(error: error)
        }
        
        viewModel.updateView = {
            self.tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
}

