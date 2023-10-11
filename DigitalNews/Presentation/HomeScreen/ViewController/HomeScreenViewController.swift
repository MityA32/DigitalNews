//
//  ViewController.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import UIKit

final class HomeScreenViewController: UIViewController {
    
    @IBOutlet private weak var customNavigationBarView: CustomNavigationBarView!
    @IBOutlet private weak var newsListTableView: UITableView!
    
    private let viewModel = HomeScreenViewModel(newsRepository: NewsRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        setupTableView()
        
    }
    
    private func setupTableView() {
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        newsListTableView.registerCell(NewsListTableViewCell.self)
        newsListTableView.rowHeight = UITableView.automaticDimension
        viewModel.loadMore(for: "popular") { [weak self] _ in
            self?.newsListTableView.reloadData()
        }
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.currentNewsListType {
            case .latest:
                viewModel.news.count
            case .saved:
                viewModel.savedNews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsListTableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.id, for: indexPath) as! NewsListTableViewCell
        cell.selectionStyle = .none
        switch viewModel.currentNewsListType {
            case .latest:
                cell.config(from: viewModel.news[indexPath.row])
            case .saved:
                cell.configSaved(from: viewModel.savedNews[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = PieceOfNewsWebViewController.instantiateFromNib()
        switch viewModel.currentNewsListType {
            case .latest:
                webViewController.url = URL(string: viewModel.news[indexPath.row].url ?? "")
            case .saved:
                webViewController.url = viewModel.savedNews[indexPath.row].url
        }
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    
}
