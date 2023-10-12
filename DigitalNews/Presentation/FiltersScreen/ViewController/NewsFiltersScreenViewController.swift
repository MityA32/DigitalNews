//
//  NewsFiltersScreenViewController.swift
//  DigitalNews
//
//  Created by Dmytro Hetman on 11.10.2023.
//

import UIKit

final class NewsFiltersScreenViewController: UIViewController {
    
    @IBOutlet private weak var newsSourcesTableView: UITableView!
    @IBOutlet private weak var selectNewsCategoryButton: UIButton!
    @IBOutlet private weak var selectNewsCountryButton: UIButton!
    
    private let viewModel = NewsFiltersScreenViewModel(sourcesRepository: SourcesRepository())
    private let activityIndicator = UIActivityIndicatorView()
    private let nothingWasFoundLabel = UILabel()
    
    var selectedCategory: NewsCategory?
    var selectedCountry: NewsCountry?
    var selectedSources: [NewsSource]?
    var sources: [NewsSource]?
    weak var transferFilterDataDelegate: NewsFilterDataTransferDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    private func setup() {
        viewModel.selectedCategory = selectedCategory
        viewModel.selectedCountry = selectedCountry
        viewModel.selectedSources = selectedSources ?? []
        viewModel.sources = sources ?? []
        setupCustomBackButton()
        setupTableView()
        setupButtons()
    }
    
    private func setupTableView() {
        newsSourcesTableView.delegate = self
        newsSourcesTableView.dataSource = self
        newsSourcesTableView.registerCell(NewsSourcesTableViewCell.self)
        newsSourcesTableView.allowsMultipleSelection = true
        setupEmptyTableViewPlaceholder()
        setupActivityIndicator()
        if viewModel.sources.isEmpty {
            updateSourcesTable()
        } else {
            newsSourcesTableView.reloadData()
        }
    }
    
    private func setupEmptyTableViewPlaceholder() {
        nothingWasFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        nothingWasFoundLabel.text = "No sources found"
        nothingWasFoundLabel.textAlignment = .center
        nothingWasFoundLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nothingWasFoundLabel.isHidden = true
        newsSourcesTableView.addSubview(nothingWasFoundLabel)
        
        NSLayoutConstraint.activate([
            nothingWasFoundLabel.centerXAnchor.constraint(equalTo: newsSourcesTableView.centerXAnchor),
            nothingWasFoundLabel.centerYAnchor.constraint(equalTo: newsSourcesTableView.centerYAnchor),
            nothingWasFoundLabel.widthAnchor.constraint(equalTo: newsSourcesTableView.widthAnchor),
            nothingWasFoundLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        newsSourcesTableView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: newsSourcesTableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: newsSourcesTableView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupButtons() {
        selectCategory()
        selectCountry()
    }
    
    private func selectCategory() {
        selectNewsCategoryButton.setTitle(viewModel.selectedCategory?.title ?? "Any", for: .normal)
        let categorySelection = viewModel.categories.map { category in
            UIAction(title: category.title) { [weak self] action in
                guard let self else { return }
                viewModel.selectedCategory = category
                selectNewsCategoryButton.setTitle(category.title, for: .normal)
                updateSourcesTable()
                viewModel.selectedSources = []   
            }
        }
        selectNewsCategoryButton.showsMenuAsPrimaryAction = true
        selectNewsCategoryButton.menu = UIMenu(options: .singleSelection, children: categorySelection)
    }

    private func selectCountry() {
        selectNewsCountryButton.setTitle(selectedCountry?.name ?? "Any", for: .normal)
        let countrySelection = viewModel.countries.map { country in
            UIAction(title: country.name) { [weak self] action in
                guard let self else { return }
                viewModel.selectedCountry = country
                selectNewsCountryButton.setTitle(country.name, for: .normal)
                updateSourcesTable()
                viewModel.selectedSources = []
            }
        }
        selectNewsCountryButton.showsMenuAsPrimaryAction = true
        selectNewsCountryButton.menu = UIMenu(options: .singleSelection, children: countrySelection)
    }
    
    private func updateSourcesTable() {
        activityIndicator.startAnimating()
        viewModel.getSources { [weak self] result in
            switch result {
                case .success(let data):
                    
                    self?.nothingWasFoundLabel.isHidden = !data.isEmpty
                    
                    self?.newsSourcesTableView.reloadData()
                    self?.activityIndicator.stopAnimating()
                    
                case .failure(let failure):
                    print("show Alert: \(failure.localizedDescription)")
            }
            
        }
    }
    
    private func setupCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(NewsFiltersScreenViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func back(sender: UIBarButtonItem) {
        let sources = !viewModel.selectedSources.isEmpty ? viewModel.sources :
                        viewModel.sources.count <= 20 ? viewModel.sources : []
        let country = (sources.isEmpty && viewModel.selectedSources.isEmpty ? .any : viewModel.selectedCountry) ?? .any
        transferFilterDataDelegate?
           .transferNewsFilterData(
            category: viewModel.selectedCategory ?? .any,
            country: country,
            sources: sources,
            selectedSources: viewModel.selectedSources)
    }
}

extension NewsFiltersScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sources.count
    }
    
    private func configureCellSelection(cell: NewsSourcesTableViewCell, indexPath: IndexPath) {
        let source = viewModel.sources[indexPath.row]
        if viewModel.selectedSources.contains(source) {
            newsSourcesTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            newsSourcesTableView.deselectRow(at: indexPath, animated: false)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsSourcesTableView.dequeueReusableCell(withIdentifier: NewsSourcesTableViewCell.id, for: indexPath) as! NewsSourcesTableViewCell
        cell.config(from: viewModel.sources[indexPath.row].name)
        cell.selectionStyle = .none
        configureCellSelection(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.selectedSources.count < 20,
           !viewModel.selectedSources.contains(viewModel.sources[indexPath.row]) {
            viewModel.selectedSources.append(viewModel.sources[indexPath.row])
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let sourceIndex = viewModel.selectedSources.firstIndex(of: viewModel.sources[indexPath.row]) {
            viewModel.selectedSources.remove(at: sourceIndex)
        }
    }

    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        viewModel.selectedSources.count < 20 ? indexPath : nil
    }
    
}
