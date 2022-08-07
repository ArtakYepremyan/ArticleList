//
//  MainViewController.swift
//  ArticleList
//
//  Created by Artak Yepremyan on 05.08.22.
//

import UIKit
import SafariServices

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "News"
        setupViewModel()
        setupBindings()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewIsReady()
    }
    
    private func setupViewModel() {
        let articlesFeedDataSource = ArticlesFeedDataSource()
        let articlesDefaultDataSource = ArticlesDefaultDataSource()
        let repository = ArticlesRepository(firstDataSource: articlesFeedDataSource, secondDataSource: articlesDefaultDataSource)
        viewModel = MainViewModel(articlesRepository: repository)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        tableView.register(UINib(nibName: "ArticleImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleImageTableViewCell")
    }
    
    private func setupBindings() {
        viewModel.showError = { error in
            self.showError(error: error)
        }
        
        viewModel.updateView = {
            self.tableView.reloadData()
        }
    }
    
    private func showSafariViewController(for url: URL) {
        let vc = SFSafariViewController(url: url)
        self.navigationController?.present(vc, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.itemForRow(row: indexPath.row)
        if item.imageURL != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleImageTableViewCell") as! ArticleImageTableViewCell
            cell.configure(article: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as! ArticleTableViewCell
            cell.configure(article: item)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let url = viewModel.itemForRow(row: indexPath.row).url {
            showSafariViewController(for: url)
        }
    }
}
