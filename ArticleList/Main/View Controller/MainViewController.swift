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
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupBindings()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewIsReady()
    }

    private func setupNavigation() {
        self.title = "News"
        let item = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func handleSaveButton() {
        
        let controller = UIAlertController(title: nil, message: "Choose file format to save", preferredStyle: .actionSheet)
        let xmlAction = UIAlertAction(title: "XML", style: .default) { _ in
            self.viewModel.saveArticles(format: .xml)
        }
        controller.addAction(xmlAction)
        let jsonAction = UIAlertAction(title: "JSON", style: .default) { _ in
            self.viewModel.saveArticles(format: .json)
        }
        controller.addAction(jsonAction)
        controller.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        self.present(controller, animated: true)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
        tableView.register(UINib(nibName: "ArticleImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleImageTableViewCell")
    }
    
    private func setupBindings() {
        viewModel.showError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showError(error: error)
            }
        }
        
        viewModel.updateView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
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
