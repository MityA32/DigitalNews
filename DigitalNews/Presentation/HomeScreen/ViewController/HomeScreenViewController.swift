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
    
    private let activityIndicator = { 
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    private let nothingWasFoundLabel = UILabel()
    
    private var isLoadingData = false
    private var debounceTimer: Timer?
    
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
        newsSearchBar.placeholder = "Search.."
        
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .primaryActionTriggered)
    }
    
    private func setupTableView() {
        newsListTableView.delegate = self
        newsListTableView.dataSource = self
        newsListTableView.registerCell(NewsListTableViewCell.self)
        newsListTableView.register(LoadingCell.self, forCellReuseIdentifier: "LoadingCell")
        newsListTableView.rowHeight = UITableView.automaticDimension
        newsListTableView.refreshControl = refreshControl
        newsListTableView.separatorStyle = .none
        setupEmptyTableViewPlaceholder()
        setupActivityIndicator()
        viewModel.loadMore() { [weak self] _ in
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
            self?.newsListTableView.reloadData()
        }
    }
    
    
    private func setupEmptyTableViewPlaceholder() {
        nothingWasFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingWasFoundLabel.text = "No news found for selected filters"
        nothingWasFoundLabel.textAlignment = .center
        nothingWasFoundLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nothingWasFoundLabel.numberOfLines = 0
        nothingWasFoundLabel.isHidden = true
        newsListTableView.addSubview(nothingWasFoundLabel)
        
        NSLayoutConstraint.activate([
            nothingWasFoundLabel.centerXAnchor.constraint(equalTo: newsListTableView.centerXAnchor),
            nothingWasFoundLabel.centerYAnchor.constraint(equalTo: newsListTableView.centerYAnchor),
            nothingWasFoundLabel.widthAnchor.constraint(equalTo: newsListTableView.widthAnchor, multiplier: 0.8),
            nothingWasFoundLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActivityIndicator() {
        newsListTableView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: newsListTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: newsListTableView.centerYAnchor)
        ])
    }
    
    private func setupFilterButton() {
        filterButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        filterButton.addTarget(self, action: #selector(openFiltersScreen), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
    @objc
    func refreshNews() {
        viewModel.refreshNews { [weak self] result in
            switch result {
            case .success(let data):
                self?.nothingWasFoundLabel.isHidden = !data.isEmpty
                self?.newsListTableView.reloadData()
                
            case .failure(let failure):
                print("Show Alert: \(failure)")
            }
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc
    func openFiltersScreen() {
        let filtersScreen = NewsFiltersScreenViewController.instantiateFromNib()
        filtersScreen.selectedCategory = viewModel.selectedCategory
        filtersScreen.selectedCountry = viewModel.selectedCountry
        filtersScreen.selectedSources = viewModel.selectedSources
        filtersScreen.sources = viewModel.sources
        filtersScreen.transferFilterDataDelegate = self
        navigationController?.pushViewController(filtersScreen, animated: false)
    }
}

extension HomeScreenViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            self?.viewModel.currentTopic = searchText
            self?.refreshNews()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoadingData ? viewModel.news.count + 1 : viewModel.news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.news.count - 1 {
            let cell = newsListTableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.id, for: indexPath) as! NewsListTableViewCell
            cell.selectionStyle = .none
            cell.config(from: viewModel.news[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell()
            activityIndicator.startAnimating()
            cell.contentView.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                activityIndicator.widthAnchor.constraint(equalToConstant: 50),
                activityIndicator.heightAnchor.constraint(equalToConstant: 50)
            ])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webViewController = PieceOfNewsWebViewController.instantiateFromNib()
        webViewController.url = URL(string: viewModel.news[indexPath.row].url ?? "")
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.news.count - 1 && !isLoadingData {
            isLoadingData = true
            viewModel.loadMore { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.isLoadingData = false
                    self?.newsListTableView.reloadData()
                }
            }
        }
    }

    
}

extension HomeScreenViewController: NewsFilterDataTransferDelegate {
    func transferNewsFilterData(
        category: NewsCategory,
        country: NewsCountry,
        sources: [NewsSource],
        selectedSources: [NewsSource]
    ) {
        viewModel.selectedCategory = category
        viewModel.selectedCountry = country
        viewModel.selectedSources = selectedSources
        viewModel.sources = sources
        refreshNews()
        navigationController?.popViewController(animated: true)
    }
}


class LoadingCell: UITableViewCell {
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        
    }
    
    
}
