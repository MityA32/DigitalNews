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
    
    var selectedCategory: NewsCategory?
    var selectedCountry: NewsCountry?
    var selectedSources: [NewsSource]?
    weak var transferFilterDataDelegate: NewsFilterDataTransferDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }

    private func setup() {
        viewModel.selectedCategory = selectedCategory
        viewModel.selectedCountry = selectedCountry
        viewModel.selectedSources = selectedSources ?? []
        setupCustomBackButton()
        setupTableView()
        setupButtons()
    }
    
    private func setupTableView() {
        newsSourcesTableView.delegate = self
        newsSourcesTableView.dataSource = self
        
        setupActivityIndicator()
        
        updateSourcesTable()
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
            }
        }
        selectNewsCountryButton.showsMenuAsPrimaryAction = true
        selectNewsCountryButton.menu = UIMenu(options: .singleSelection, children: countrySelection)
    }
    
    private func updateSourcesTable() {
        activityIndicator.startAnimating()
        viewModel.getSources { [weak self] result in
            switch result {
                case .success(_):
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
       let sources = viewModel.selectedSources.isEmpty ? viewModel.sources : viewModel.selectedSources
       transferFilterDataDelegate?
           .transferNewsFilterData(
            category: viewModel.selectedCategory ?? .any,
            country: viewModel.selectedCountry ?? .any,
            sources: sources)
    }
}

extension NewsFiltersScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.sources[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
    
}
