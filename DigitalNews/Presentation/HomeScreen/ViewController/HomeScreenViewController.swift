//
//  ViewController.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 03.10.2023.
//

import UIKit

final class HomeScreenViewController: UIViewController {
    
    @IBOutlet private weak var newsSearchBar: UISearchBar!
    @IBOutlet private weak var newsListTableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let filterButton = UIButton()
    
    private let viewModel = HomeScreenViewModel(newsRepository: NewsRepository())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        title = "News"
        setupSearhBar()
        setupRefreshControl()
        setupTableView()
        setupFilterButton()
    }
    
    private func setupSearhBar() {
        newsSearchBar.delegate = self
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .primaryActionTriggered)
    }
    
    private func setupTableView() {
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        newsListTableView.registerCell(NewsListTableViewCell.self)
        newsListTableView.rowHeight = UITableView.automaticDimension
        newsListTableView.refreshControl = refreshControl
        viewModel.loadMore() { [weak self] _ in
            self?.newsListTableView.reloadData()
        }
    }
    
    private func setupFilterButton() {
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.addTarget(self, action: #selector(openFiltersScreen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    @objc
    func refreshNews() {
        viewModel.refreshNews { [weak self] _ in
            self?.newsListTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc
    func openFiltersScreen() {
        let filtersScreen = NewsFiltersScreenViewController.instantiateFromNib()
        filtersScreen.selectedCategory = viewModel.selectedCategory
        filtersScreen.selectedCountry = viewModel.selectedCountry
        filtersScreen.transferFilterDataDelegate = self
        navigationController?.pushViewController(filtersScreen, animated: false)
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsListTableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.id, for: indexPath) as! NewsListTableViewCell

        cell.selectionStyle = .none
        cell.config(from: viewModel.news[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = PieceOfNewsWebViewController.instantiateFromNib()
        webViewController.url = URL(string: viewModel.news[indexPath.row].url ?? "")
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}

extension HomeScreenViewController: NewsFilterDataTransferDelegate {
    func transferNewsFilterData(category: NewsCategory, country: NewsCountry, sources: [NewsSource]) {
        viewModel.selectedCategory = category
        viewModel.selectedCountry = country
        viewModel.selectedSources = sources
        refreshNews()
        navigationController?.popViewController(animated: true)
    }
}
